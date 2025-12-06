package com.helger.schematron;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.base.id.IHasID;
import com.helger.base.lang.EnumHelper;

/**
 * Defines the Schematron engine to be used.
 *
 * @author Philip Helger
 */
public enum ESchematronEngine implements IHasID <String>
{
  PURE ("pure"),
  ISO_SCHEMATRON ("iso-schematron"),
  SCHXSLT ("schxslt"),
  SCHXSLT2 ("schxslt2");

  private final String m_sID;

  ESchematronEngine (@NonNull @Nonempty final String sID)
  {
    m_sID = sID;
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
    return EnumHelper.getFromIDOrNull (ESchematronEngine.class, sID);
  }
}
