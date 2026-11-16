/*
 * Copyright (C) 2015-2026 Philip Helger (www.helger.com)
 * philip[at]helger[dot]com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.helger.schematron.model;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.PresentForCodeCoverage;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.state.EContinue;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.xml.microdom.IMicroElement;

/**
 * Walks a {@link PSSchema} or a {@link PSLibrary} and invokes an {@link IPSVisitor} for every
 * contained element.<br>
 * Elements with mixed content (like <code>&lt;assert&gt;</code> or <code>&lt;p&gt;</code>) are
 * visited in document order. The children of all other elements are visited in a fixed order by
 * element type, as the model does not retain the original order between different element types.
 * In that case foreign elements are visited first. Includes and extends are reported but not
 * resolved - visit a preprocessed schema to get the resolved content.
 *
 * @author Philip Helger
 * @since 10.3.1
 */
@Immutable
public final class PSVisitor
{
  @PresentForCodeCoverage
  private static final PSVisitor INSTANCE = new PSVisitor ();

  private PSVisitor ()
  {}

  /**
   * Invoke the callback for an element without children.
   *
   * @param aParent
   *        The parent element. May not be <code>null</code>.
   * @param aObject
   *        The object to be visited. May not be <code>null</code>.
   * @param aVisitor
   *        The visitor to be invoked. May not be <code>null</code>.
   * @return <code>null</code> if the passed object may have children.
   */
  @Nullable
  private static EContinue _visitLeaf (@NonNull final IPSElement aParent,
                                       @NonNull final Object aObject,
                                       @NonNull final IPSVisitor aVisitor)
  {
    return switch (aObject)
    {
      case final String sText -> aVisitor.onTextContent (aParent, sText);
      case final IMicroElement aForeignElement -> aVisitor.onForeignElement (aParent, aForeignElement);
      case final PSInclude aInclude -> aVisitor.onInclude (aParent, aInclude);
      case final PSExtends aExtends -> aVisitor.onExtends (aParent, aExtends);
      case final PSNS aNs -> aVisitor.onNs (aParent, aNs);
      case final PSParam aParam -> aVisitor.onParam (aParent, aParam);
      case final PSLet aLet -> aVisitor.onLet (aParent, aLet);
      case final PSName aName -> aVisitor.onName (aParent, aName);
      case final PSValueOf aValueOf -> aVisitor.onValueOf (aParent, aValueOf);
      default -> null;
    };
  }

  @NonNull
  private static EContinue _onStart (@NonNull final Object aObject, @NonNull final IPSVisitor aVisitor)
  {
    return switch (aObject)
    {
      case final PSSchema aSchema -> aVisitor.onSchemaStart (aSchema);
      case final PSLibrary aLibrary -> aVisitor.onLibraryStart (aLibrary);
      case final PSTitle aTitle -> aVisitor.onTitleStart (aTitle);
      case final PSP aP -> aVisitor.onPStart (aP);
      case final PSPhase aPhase -> aVisitor.onPhaseStart (aPhase);
      case final PSActive aActive -> aVisitor.onActiveStart (aActive);
      case final PSRules aRules -> aVisitor.onRulesStart (aRules);
      case final PSPattern aPattern -> aVisitor.onPatternStart (aPattern);
      case final PSGroup aGroup -> aVisitor.onGroupStart (aGroup);
      case final PSRule aRule -> aVisitor.onRuleStart (aRule);
      case final PSAssertReport aAssertReport -> aVisitor.onAssertReportStart (aAssertReport);
      case final PSDiagnostics aDiagnostics -> aVisitor.onDiagnosticsStart (aDiagnostics);
      case final PSDiagnostic aDiagnostic -> aVisitor.onDiagnosticStart (aDiagnostic);
      case final PSProperties aProperties -> aVisitor.onPropertiesStart (aProperties);
      case final PSProperty aProperty -> aVisitor.onPropertyStart (aProperty);
      case final PSDir aDir -> aVisitor.onDirStart (aDir);
      case final PSEmph aEmph -> aVisitor.onEmphStart (aEmph);
      case final PSSpan aSpan -> aVisitor.onSpanStart (aSpan);
      default -> throw new IllegalStateException ("Unsupported Schematron object to visit: " + aObject);
    };
  }

  @NonNull
  @ReturnsMutableCopy
  private static ICommonsList <Object> _getAllChildren (@NonNull final IPSElement aElement)
  {
    final ICommonsList <Object> ret = new CommonsArrayList <> ();
    switch (aElement)
    {
      case final PSSchema aSchema ->
      {
        ret.addAll (aSchema.getAllForeignElements ());
        ret.addAll (aSchema.getAllIncludes ());
        ret.addAll (aSchema.getAllExtends ());
        if (aSchema.hasTitle ())
          ret.add (aSchema.getTitle ());
        ret.addAll (aSchema.getAllNSs ());
        ret.addAll (aSchema.getAllStartPs ());
        ret.addAll (aSchema.getAllParams ());
        ret.addAll (aSchema.getAllLets ());
        ret.addAll (aSchema.getAllPhases ());
        ret.addAll (aSchema.getAllAbstractRulesContainers ());
        ret.addAll (aSchema.getAllPatterns ());
        ret.addAll (aSchema.getAllGroups ());
        ret.addAll (aSchema.getAllEndPs ());
        if (aSchema.hasDiagnostics ())
          ret.add (aSchema.getDiagnostics ());
        if (aSchema.hasProperties ())
          ret.add (aSchema.getProperties ());
      }
      case final PSLibrary aLibrary ->
      {
        // Foreign elements of a library are not retained in the model
        ret.addAll (aLibrary.getAllIncludes ());
        ret.addAll (aLibrary.getAllExtends ());
        if (aLibrary.hasTitle ())
          ret.add (aLibrary.getTitle ());
        ret.addAll (aLibrary.getAllStartPs ());
        ret.addAll (aLibrary.getAllParams ());
        ret.addAll (aLibrary.getAllLets ());
        ret.addAll (aLibrary.getAllAbstractRulesContainers ());
        ret.addAll (aLibrary.getAllPatterns ());
        ret.addAll (aLibrary.getAllGroups ());
        ret.addAll (aLibrary.getAllEndPs ());
        if (aLibrary.hasDiagnostics ())
          ret.add (aLibrary.getDiagnostics ());
        if (aLibrary.hasProperties ())
          ret.add (aLibrary.getProperties ());
      }
      case final PSPhase aPhase ->
      {
        ret.addAll (aPhase.getAllForeignElements ());
        ret.addAll (aPhase.getAllIncludes ());
        // p, let and active in document order
        ret.addAll (aPhase.getAllContentElements ());
      }
      case final PSRules aRules ->
      {
        if (aRules.hasTitle ())
          ret.add (aRules.getTitle ());
        ret.addAll (aRules.getAllPs ());
        ret.addAll (aRules.getAllAbstractRules ());
      }
      case final AbstractPSPatternLike aPatternLike ->
      {
        // Patterns and groups share the content model
        ret.addAll (aPatternLike.getAllForeignElements ());
        ret.addAll (aPatternLike.getAllIncludes ());
        if (aPatternLike.hasTitle ())
          ret.add (aPatternLike.getTitle ());
        // p, let, rule and param in document order
        ret.addAll (aPatternLike.getAllContentElements ());
      }
      case final PSRule aRule ->
      {
        ret.addAll (aRule.getAllForeignElements ());
        ret.addAll (aRule.getAllIncludes ());
        ret.addAll (aRule.getAllLets ());
        // assert, report and extends in document order
        ret.addAll (aRule.getAllContentElements ());
      }
      case final PSDiagnostics aDiagnostics ->
      {
        ret.addAll (aDiagnostics.getAllForeignElements ());
        ret.addAll (aDiagnostics.getAllIncludes ());
        ret.addAll (aDiagnostics.getAllDiagnostics ());
      }
      case final PSProperties aProperties -> ret.addAll (aProperties.getAllProperties ());
      // Texts and child elements including foreign elements in document order
      case final IPSHasMixedContent aMixedContent -> ret.addAll (aMixedContent.getAllContentElements ());
      case final PSDir aDir -> ret.addAll (aDir.getAllContentElements ());
      case final PSEmph aEmph -> ret.addAll (aEmph.getAllContentElements ());
      case final PSSpan aSpan -> ret.addAll (aSpan.getAllContentElements ());
      default ->
      {
        // No children
      }
    }
    return ret;
  }

  @NonNull
  private static EContinue _onEnd (@NonNull final IPSElement aElement, @NonNull final IPSVisitor aVisitor)
  {
    return switch (aElement)
    {
      case final PSSchema aSchema -> aVisitor.onSchemaEnd (aSchema);
      case final PSLibrary aLibrary -> aVisitor.onLibraryEnd (aLibrary);
      case final PSTitle aTitle -> aVisitor.onTitleEnd (aTitle);
      case final PSP aP -> aVisitor.onPEnd (aP);
      case final PSPhase aPhase -> aVisitor.onPhaseEnd (aPhase);
      case final PSActive aActive -> aVisitor.onActiveEnd (aActive);
      case final PSRules aRules -> aVisitor.onRulesEnd (aRules);
      case final PSPattern aPattern -> aVisitor.onPatternEnd (aPattern);
      case final PSGroup aGroup -> aVisitor.onGroupEnd (aGroup);
      case final PSRule aRule -> aVisitor.onRuleEnd (aRule);
      case final PSAssertReport aAssertReport -> aVisitor.onAssertReportEnd (aAssertReport);
      case final PSDiagnostics aDiagnostics -> aVisitor.onDiagnosticsEnd (aDiagnostics);
      case final PSDiagnostic aDiagnostic -> aVisitor.onDiagnosticEnd (aDiagnostic);
      case final PSProperties aProperties -> aVisitor.onPropertiesEnd (aProperties);
      case final PSProperty aProperty -> aVisitor.onPropertyEnd (aProperty);
      case final PSDir aDir -> aVisitor.onDirEnd (aDir);
      case final PSEmph aEmph -> aVisitor.onEmphEnd (aEmph);
      case final PSSpan aSpan -> aVisitor.onSpanEnd (aSpan);
      default -> throw new IllegalStateException ("Unsupported Schematron element to visit: " + aElement);
    };
  }

  @NonNull
  private static EContinue _visitRecursive (@NonNull final Object aObject, @NonNull final IPSVisitor aVisitor)
  {
    // Throws an exception for unsupported objects
    if (_onStart (aObject, aVisitor).isBreak ())
      return EContinue.BREAK;

    final IPSElement aElement = (IPSElement) aObject;
    for (final Object aChild : _getAllChildren (aElement))
    {
      EContinue eResult = _visitLeaf (aElement, aChild, aVisitor);
      if (eResult == null)
        eResult = _visitRecursive (aChild, aVisitor);
      if (eResult.isBreak ())
        return EContinue.BREAK;
    }
    return _onEnd (aElement, aVisitor);
  }

  /**
   * Walk the whole schema and invoke the visitor for each contained element.
   *
   * @param aSchema
   *        The schema to be visited. May not be <code>null</code>.
   * @param aVisitor
   *        The visitor to be invoked. May not be <code>null</code>.
   * @return {@link EContinue#BREAK} if the visitor stopped the walk, {@link EContinue#CONTINUE}
   *         if the whole schema was visited.
   */
  @NonNull
  public static EContinue visit (@NonNull final PSSchema aSchema, @NonNull final IPSVisitor aVisitor)
  {
    ValueEnforcer.notNull (aSchema, "Schema");
    ValueEnforcer.notNull (aVisitor, "Visitor");

    return _visitRecursive (aSchema, aVisitor);
  }

  /**
   * Walk the whole schema and invoke the visitor for each contained element.
   *
   * @param aSchema
   *        The schema to be visited. May not be <code>null</code>.
   * @param aVisitor
   *        The visitor to be invoked. May not be <code>null</code>.
   */
  public static void visit (@NonNull final PSSchema aSchema, @NonNull final IPSVoidVisitor aVisitor)
  {
    ValueEnforcer.notNull (aVisitor, "Visitor");

    visit (aSchema, new PSVoidVisitorWrapper (aVisitor));
  }

  /**
   * Walk the whole library and invoke the visitor for each contained element.
   *
   * @param aLibrary
   *        The library to be visited. May not be <code>null</code>.
   * @param aVisitor
   *        The visitor to be invoked. May not be <code>null</code>.
   * @return {@link EContinue#BREAK} if the visitor stopped the walk, {@link EContinue#CONTINUE}
   *         if the whole library was visited.
   */
  @NonNull
  public static EContinue visit (@NonNull final PSLibrary aLibrary, @NonNull final IPSVisitor aVisitor)
  {
    ValueEnforcer.notNull (aLibrary, "Library");
    ValueEnforcer.notNull (aVisitor, "Visitor");

    return _visitRecursive (aLibrary, aVisitor);
  }

  /**
   * Walk the whole library and invoke the visitor for each contained element.
   *
   * @param aLibrary
   *        The library to be visited. May not be <code>null</code>.
   * @param aVisitor
   *        The visitor to be invoked. May not be <code>null</code>.
   */
  public static void visit (@NonNull final PSLibrary aLibrary, @NonNull final IPSVoidVisitor aVisitor)
  {
    ValueEnforcer.notNull (aVisitor, "Visitor");

    visit (aLibrary, new PSVoidVisitorWrapper (aVisitor));
  }
}
