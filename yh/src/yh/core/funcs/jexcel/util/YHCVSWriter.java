package yh.core.funcs.jexcel.util;

/**
 Copyright 2005 Bytecode Pty Ltd.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import java.io.Closeable;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;

import yh.core.data.YHDbRecord;
import yh.core.util.YHUtility;

/**
 * A very simple CSV writer released under a commercial-friendly license.
 * 
 * @author Glen Smith
 * 
 */
public class YHCVSWriter implements Closeable {

  public static final int INITIAL_STRING_SIZE = 128;

  private Writer rawWriter;

  private PrintWriter pw;

  private char separator;

  private char quotechar;

  private char escapechar;

  private String lineEnd;

  /** The character used for escaping quotes. */
  public static final char DEFAULT_ESCAPE_CHARACTER = '\\';

  /** The default separator to use if none is supplied to the constructor. */
  public static final char DEFAULT_SEPARATOR = ',';

  /**
   * The default quote character to use if none is supplied to the constructor.
   */
  public static final char DEFAULT_QUOTE_CHARACTER = '"';

  /** The quote constant to use when you wish to suppress all quoting. */
  public static final char NO_QUOTE_CHARACTER = '\u0000';

  /** The escape constant to use when you wish to suppress all escaping. */
  public static final char NO_ESCAPE_CHARACTER = '\u0000';

  /** Default line terminator uses platform encoding. */
  public static final String DEFAULT_LINE_END = "\r\n";

  /**
   * Constructs CSVWriter using a comma for the separator.
   * 
   * @param writer
   *          the writer to an underlying CSV source.
   */
  public YHCVSWriter(Writer writer) {
    this(writer, DEFAULT_SEPARATOR);
  }

  /**
   * Constructs CSVWriter with supplied separator.
   * 
   * @param writer
   *          the writer to an underlying CSV source.
   * @param separator
   *          the delimiter to use for separating entries.
   */
  public YHCVSWriter(Writer writer, char separator) {
    this(writer, separator, DEFAULT_QUOTE_CHARACTER);
  }

  /**
   * Constructs CSVWriter with supplied separator and quote char.
   * 
   * @param writer
   *          the writer to an underlying CSV source.
   * @param separator
   *          the delimiter to use for separating entries
   * @param quotechar
   *          the character to use for quoted elements
   */
  public YHCVSWriter(Writer writer, char separator, char quotechar) {
    this(writer, separator, quotechar, DEFAULT_ESCAPE_CHARACTER);
  }

  /**
   * Constructs CSVWriter with supplied separator and quote char.
   * 
   * @param writer
   *          the writer to an underlying CSV source.
   * @param separator
   *          the delimiter to use for separating entries
   * @param quotechar
   *          the character to use for quoted elements
   * @param escapechar
   *          the character to use for escaping quotechars or escapechars
   */
  public YHCVSWriter(Writer writer, char separator, char quotechar,
      char escapechar) {
    this(writer, separator, quotechar, escapechar, DEFAULT_LINE_END);
  }

  /**
   * Constructs CSVWriter with supplied separator and quote char.
   * 
   * @param writer
   *          the writer to an underlying CSV source.
   * @param separator
   *          the delimiter to use for separating entries
   * @param quotechar
   *          the character to use for quoted elements
   * @param lineEnd
   *          the line feed terminator to use
   */
  public YHCVSWriter(Writer writer, char separator, char quotechar,
      String lineEnd) {
    this(writer, separator, quotechar, DEFAULT_ESCAPE_CHARACTER, lineEnd);
  }

  /**
   * Constructs CSVWriter with supplied separator, quote char, escape char and
   * line ending.
   * 
   * @param writer
   *          the writer to an underlying CSV source.
   * @param separator
   *          the delimiter to use for separating entries
   * @param quotechar
   *          the character to use for quoted elements
   * @param escapechar
   *          the character to use for escaping quotechars or escapechars
   * @param lineEnd
   *          the line feed terminator to use
   */
  public YHCVSWriter(Writer writer, char separator, char quotechar,
      char escapechar, String lineEnd) {
    this.rawWriter = writer;
    this.pw = new PrintWriter(writer);
    this.separator = separator;
    this.quotechar = quotechar;
    this.escapechar = escapechar;
    this.lineEnd = lineEnd;
  }

  /**
   * Writes the entire list to a CSV file. The list is assumed to be a String[]
   * 
   * @param allLines
   *          a List of String[], with each String[] representing a line of the
   *          file.
   */
  public void writeAll(List<String[]> allLines) {
    for (String[] line : allLines) {
      writeNext(line);
    }
  }

  /**
   * Writes the next line to the file.
   * 
   * @param nextLine
   *          a string array with each comma-separated element as a separate
   *          entry.
   */
  public void writeNext(String[] nextLine) {
    if (nextLine == null) {
      return;
    }
    StringBuilder sb = new StringBuilder(INITIAL_STRING_SIZE);
    for (int i = 0; i < nextLine.length; i++) {
      if (i != 0) {
        sb.append(separator);
      }
      String nextElement = nextLine[i];
      if (nextElement == null) {
        continue;
      }
      if (quotechar != NO_QUOTE_CHARACTER) {
        sb.append(quotechar);
      }
      sb.append(stringContainsSpecialCharacters(nextElement) ? processLine(nextElement) : nextElement);
      if (quotechar != NO_QUOTE_CHARACTER) {
        sb.append(quotechar);
      }
    }

    sb.append(lineEnd);
    pw.write(sb.toString());
  }

  public void writeAll(ArrayList<YHDbRecord> allLines) {
    String[] headers = null;
    String[][] data = new String[allLines.size() + 1][];
    for (int i = 0; i < allLines.size(); i++) {
      YHDbRecord dbr = allLines.get(i);
      String[] values = null;
      if(i == 0){
        headers = new String[dbr.getFieldCnt()];
      }
      values = new String[dbr.getFieldCnt()];
      for (int j = 0; j < dbr.getFieldCnt(); j++) {
        if( i == 0){
          headers[j] = dbr.getNameByIndex(j);
        }
       values[j] =  dbr.getValueByIndex(j) == null ? "" : dbr.getValueByIndex(j).toString();
        
      }
      if( i == 0){
        data[i] = headers;
      }
      data[i + 1] = values;
    }
    
    for (int i = 0; i < data.length; i++) {
      writeNext(data[i]);
    }
  }

  private boolean stringContainsSpecialCharacters(String line) {
    return line.indexOf(quotechar) != -1 || line.indexOf(escapechar) != -1;
  }

  private StringBuilder processLine(String nextElement) {
    StringBuilder sb = new StringBuilder(INITIAL_STRING_SIZE);
    for (int j = 0; j < nextElement.length(); j++) {
      char nextChar = nextElement.charAt(j);
      if (escapechar != NO_ESCAPE_CHARACTER && nextChar == quotechar) {
        sb.append(escapechar).append(nextChar);
      } else if (escapechar != NO_ESCAPE_CHARACTER && nextChar == escapechar) {
        sb.append(escapechar).append(nextChar);
      } else {
        sb.append(nextChar);
      }
    }

    return sb;
  }

  /**
   * Flush underlying stream to writer.
   * 
   * @throws IOException
   *           if bad things happen
   */
  public void flush() throws IOException {
    pw.flush();
  }

  /**
   * Close the underlying stream writer flushing any buffered content.
   * 
   * @throws IOException
   *           if bad things happen
   * 
   */
  public void close() throws IOException {
    pw.flush();
    pw.close();
    rawWriter.close();
  }

}
