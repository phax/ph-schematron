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
 * Walks a {@link PSSchema} and invokes an {@link IPSVisitor} for every contained element.<br>
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
    if (aObject instanceof final String sText)
      return aVisitor.onTextContent (aParent, sText);
    if (aObject instanceof final IMicroElement aForeignElement)
      return aVisitor.onForeignElement (aParent, aForeignElement);
    if (aObject instanceof final PSInclude aInclude)
      return aVisitor.onInclude (aParent, aInclude);
    if (aObject instanceof final PSExtends aExtends)
      return aVisitor.onExtends (aParent, aExtends);
    if (aObject instanceof final PSNS aNs)
      return aVisitor.onNs (aParent, aNs);
    if (aObject instanceof final PSParam aParam)
      return aVisitor.onParam (aParent, aParam);
    if (aObject instanceof final PSLet aLet)
      return aVisitor.onLet (aParent, aLet);
    if (aObject instanceof final PSName aName)
      return aVisitor.onName (aParent, aName);
    if (aObject instanceof final PSValueOf aValueOf)
      return aVisitor.onValueOf (aParent, aValueOf);
    return null;
  }

  @NonNull
  private static EContinue _onStart (@NonNull final Object aObject, @NonNull final IPSVisitor aVisitor)
  {
    if (aObject instanceof final PSSchema aSchema)
      return aVisitor.onSchemaStart (aSchema);
    if (aObject instanceof final PSTitle aTitle)
      return aVisitor.onTitleStart (aTitle);
    if (aObject instanceof final PSP aP)
      return aVisitor.onPStart (aP);
    if (aObject instanceof final PSPhase aPhase)
      return aVisitor.onPhaseStart (aPhase);
    if (aObject instanceof final PSActive aActive)
      return aVisitor.onActiveStart (aActive);
    if (aObject instanceof final PSRules aRules)
      return aVisitor.onRulesStart (aRules);
    if (aObject instanceof final PSPattern aPattern)
      return aVisitor.onPatternStart (aPattern);
    if (aObject instanceof final PSGroup aGroup)
      return aVisitor.onGroupStart (aGroup);
    if (aObject instanceof final PSRule aRule)
      return aVisitor.onRuleStart (aRule);
    if (aObject instanceof final PSAssertReport aAssertReport)
      return aVisitor.onAssertReportStart (aAssertReport);
    if (aObject instanceof final PSDiagnostics aDiagnostics)
      return aVisitor.onDiagnosticsStart (aDiagnostics);
    if (aObject instanceof final PSDiagnostic aDiagnostic)
      return aVisitor.onDiagnosticStart (aDiagnostic);
    if (aObject instanceof final PSProperties aProperties)
      return aVisitor.onPropertiesStart (aProperties);
    if (aObject instanceof final PSProperty aProperty)
      return aVisitor.onPropertyStart (aProperty);
    if (aObject instanceof final PSDir aDir)
      return aVisitor.onDirStart (aDir);
    if (aObject instanceof final PSEmph aEmph)
      return aVisitor.onEmphStart (aEmph);
    if (aObject instanceof final PSSpan aSpan)
      return aVisitor.onSpanStart (aSpan);
    throw new IllegalStateException ("Unsupported Schematron object to visit: " + aObject);
  }

  @NonNull
  @ReturnsMutableCopy
  private static ICommonsList <Object> _getAllChildren (@NonNull final IPSElement aElement)
  {
    final ICommonsList <Object> ret = new CommonsArrayList <> ();
    if (aElement instanceof final PSSchema aSchema)
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
    else
      if (aElement instanceof final PSPhase aPhase)
      {
        ret.addAll (aPhase.getAllForeignElements ());
        ret.addAll (aPhase.getAllIncludes ());
        // p, let and active in document order
        ret.addAll (aPhase.getAllContentElements ());
      }
      else
        if (aElement instanceof final PSRules aRules)
        {
          if (aRules.hasTitle ())
            ret.add (aRules.getTitle ());
          ret.addAll (aRules.getAllPs ());
          ret.addAll (aRules.getAllAbstractRules ());
        }
        else
          if (aElement instanceof final AbstractPSPatternLike aPatternLike)
          {
            // Patterns and groups share the content model
            ret.addAll (aPatternLike.getAllForeignElements ());
            ret.addAll (aPatternLike.getAllIncludes ());
            if (aPatternLike.hasTitle ())
              ret.add (aPatternLike.getTitle ());
            // p, let, rule and param in document order
            ret.addAll (aPatternLike.getAllContentElements ());
          }
          else
            if (aElement instanceof final PSRule aRule)
            {
              ret.addAll (aRule.getAllForeignElements ());
              ret.addAll (aRule.getAllIncludes ());
              ret.addAll (aRule.getAllLets ());
              // assert, report and extends in document order
              ret.addAll (aRule.getAllContentElements ());
            }
            else
              if (aElement instanceof final PSDiagnostics aDiagnostics)
              {
                ret.addAll (aDiagnostics.getAllForeignElements ());
                ret.addAll (aDiagnostics.getAllIncludes ());
                ret.addAll (aDiagnostics.getAllDiagnostics ());
              }
              else
                if (aElement instanceof final PSProperties aProperties)
                  ret.addAll (aProperties.getAllProperties ());
                else
                  if (aElement instanceof final IPSHasMixedContent aMixedContent)
                  {
                    // Texts and child elements including foreign elements in document order
                    ret.addAll (aMixedContent.getAllContentElements ());
                  }
                  else
                    if (aElement instanceof final PSDir aDir)
                      ret.addAll (aDir.getAllContentElements ());
                    else
                      if (aElement instanceof final PSEmph aEmph)
                        ret.addAll (aEmph.getAllContentElements ());
                      else
                        if (aElement instanceof final PSSpan aSpan)
                          ret.addAll (aSpan.getAllContentElements ());
    return ret;
  }

  @NonNull
  private static EContinue _onEnd (@NonNull final IPSElement aElement, @NonNull final IPSVisitor aVisitor)
  {
    if (aElement instanceof final PSSchema aSchema)
      return aVisitor.onSchemaEnd (aSchema);
    if (aElement instanceof final PSTitle aTitle)
      return aVisitor.onTitleEnd (aTitle);
    if (aElement instanceof final PSP aP)
      return aVisitor.onPEnd (aP);
    if (aElement instanceof final PSPhase aPhase)
      return aVisitor.onPhaseEnd (aPhase);
    if (aElement instanceof final PSActive aActive)
      return aVisitor.onActiveEnd (aActive);
    if (aElement instanceof final PSRules aRules)
      return aVisitor.onRulesEnd (aRules);
    if (aElement instanceof final PSPattern aPattern)
      return aVisitor.onPatternEnd (aPattern);
    if (aElement instanceof final PSGroup aGroup)
      return aVisitor.onGroupEnd (aGroup);
    if (aElement instanceof final PSRule aRule)
      return aVisitor.onRuleEnd (aRule);
    if (aElement instanceof final PSAssertReport aAssertReport)
      return aVisitor.onAssertReportEnd (aAssertReport);
    if (aElement instanceof final PSDiagnostics aDiagnostics)
      return aVisitor.onDiagnosticsEnd (aDiagnostics);
    if (aElement instanceof final PSDiagnostic aDiagnostic)
      return aVisitor.onDiagnosticEnd (aDiagnostic);
    if (aElement instanceof final PSProperties aProperties)
      return aVisitor.onPropertiesEnd (aProperties);
    if (aElement instanceof final PSProperty aProperty)
      return aVisitor.onPropertyEnd (aProperty);
    if (aElement instanceof final PSDir aDir)
      return aVisitor.onDirEnd (aDir);
    if (aElement instanceof final PSEmph aEmph)
      return aVisitor.onEmphEnd (aEmph);
    if (aElement instanceof final PSSpan aSpan)
      return aVisitor.onSpanEnd (aSpan);
    throw new IllegalStateException ("Unsupported Schematron element to visit: " + aElement);
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
}
