package com.helger.schematron;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.base.id.IHasID;
import com.helger.base.string.StringHelper;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.ICommonsSet;

/**
 * Defines the Schematron engine to be used.
 *
 * @author Philip Helger
 */
public enum ESchematronEngine implements IHasID <String>
{
  PURE ("pure", new CommonsHashSet <> ()),
  ISO_SCHEMATRON ("iso-schematron", new CommonsHashSet <> ("iso", "isoschematron")),
  SCHXSLT1 ("schxslt", new CommonsHashSet <> ("schxslt1")),
  SCHXSLT2 ("schxslt2", new CommonsHashSet <> ());

  private final @NonNull @Nonempty String m_sID;
  private final @NonNull ICommonsSet <String> m_aIDs;

  ESchematronEngine (@NonNull @Nonempty final String sID, @NonNull final ICommonsSet <String> aAlternativeIDs)
  {
    m_sID = sID;

    m_aIDs = aAlternativeIDs;
    m_aIDs.add (sID);
  }

  @NonNull
  @Nonempty
  public String getID ()
  {
    return m_sID;
  }

  @Nullable
  public static ESchematronEngine getFromIDOrNull (@Nullable final String sID)
  {
    if (StringHelper.isNotEmpty (sID))
      for (final ESchematronEngine e : values ())
        if (e.m_aIDs.contains (sID))
          return e;
    return null;
  }
}
