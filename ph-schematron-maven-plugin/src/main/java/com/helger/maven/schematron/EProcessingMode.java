package com.helger.maven.schematron;

import java.util.Locale;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import com.helger.commons.annotation.Nonempty;
import com.helger.commons.string.StringHelper;

public enum EProcessingMode
{
  PURE,
  SCHEMATRON,
  XSLT;

  @Nonnull
  @Nonempty
  public String getID ()
  {
    return name ().toLowerCase (Locale.US);
  }

  @Nullable
  public static EProcessingMode getFromIDOrNull (@Nullable final String sID)
  {
    if (StringHelper.hasText (sID))
      for (final EProcessingMode e : values ())
        if (e.getID ().equals (sID))
          return e;
    return null;
  }
}
