package com.github.rtyler.presentations;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Demo {
  public String echo(String message) {
    LoggerFactory.getLogger("Demo-Log").info("logging a message");
    return String.format("echoing \"%s\"", message);
  }
}
