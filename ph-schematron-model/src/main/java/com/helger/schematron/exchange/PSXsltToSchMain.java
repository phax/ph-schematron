/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.schematron.exchange;

import java.io.File;

import org.jspecify.annotations.NonNull;

import com.helger.io.resource.FileSystemResource;
import com.helger.schematron.model.PSSchema;
import com.helger.xml.serialize.write.EXMLSerializeIndent;
import com.helger.xml.serialize.write.XMLWriterSettings;

/**
 * Command line tool that converts an XSLT created from an ISO Schematron back to a Schematron
 * <code>.sch</code> file. See {@link PSXsltReader} for what can and cannot be restored.<br>
 * Usage: <code>PSXsltToSchMain &lt;input.xslt&gt; [&lt;output.sch&gt;]</code>. If no output file is
 * provided, the Schematron is written to standard out.<br>
 * The output is indented. As a side effect a message that ends with a <code>name</code> or
 * <code>value-of</code> element gets a line break before its closing tag.
 *
 * @author Philip Helger
 * @since 10.2.1
 */
public final class PSXsltToSchMain
{
  private PSXsltToSchMain ()
  {}

  public static void main (@NonNull final String [] aArgs) throws Exception
  {
    if (aArgs.length < 1 || aArgs.length > 2)
    {
      System.err.println ("Usage: " + PSXsltToSchMain.class.getSimpleName () + " <input.xslt> [<output.sch>]");
      System.exit (1);
    }

    final PSSchema aSchema = new PSXsltReader (new FileSystemResource (new File (aArgs[0]))).readSchema ();
    final PSWriter aWriter = new PSWriter (new PSWriterSettings ().setXMLWriterSettings (new XMLWriterSettings ().setIndent (EXMLSerializeIndent.INDENT_AND_ALIGN)));
    if (aArgs.length == 2)
    {
      if (aWriter.writeToFile (aSchema, new File (aArgs[1])).isFailure ())
      {
        System.err.println ("Failed to write " + aArgs[1]);
        System.exit (2);
      }
    }
    else
      System.out.println (aWriter.getXMLStringNotNull (aSchema));
  }
}
