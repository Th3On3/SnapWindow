/*
 * Filename: launcher.js
 *
 * Copyright (c) 2020 Fernando Manuel Fernandes Rodrigues <fmfrodrigues@gmail.com>
 */
var wshShell = WScript.CreateObject("WScript.Shell");
var objArgs = WScript.Arguments;
var args="";
for (i = 0; i < objArgs.length; i++){
  if (args=="")  {
    args+=objArgs(i);
  }
  else{
    args+=" "+objArgs(i);
  }
}
wshShell.Run(
  '%SystemRoot%\\system32\\WindowsPowerShell\\v1.0\\powershell.exe -executionpolicy bypass -Command &{' + args + '} ',
  0,
  false
);
