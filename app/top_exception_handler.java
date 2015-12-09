public void dumpToFile(android.app.Activity app, java.lang.String report, java.lang.String filename) {
    try {
        java.io.FileOutputStream trace =
            app.openFileOutput(filename,
                               android.content.Context.MODE_PRIVATE);
        trace.write(report.getBytes());
        trace.close();
    } catch(java.io.IOException ioe) {
        // ...
    }
}

public boolean _checkAndSendStackTrace(android.app.Activity app, java.lang.String filename, java.lang.String email) {
    java.lang.String trace = "";
    try {
        java.io.BufferedReader reader =
            new java.io.BufferedReader(
                                       new java.io.InputStreamReader(app.openFileInput(filename)));
        java.lang.String line = "";
        while((line = reader.readLine()) != null) {
            trace += line + "\n";
        }
    } catch(java.io.FileNotFoundException fnfe) {
        return false;
    } catch(java.io.IOException ioe) {
        return false;
    }

    android.content.Intent sendIntent = new android.content.Intent(android.content.Intent.ACTION_SEND);
    java.lang.String subject = "Alenkator error report";
    java.lang.String body =
        "Error trace:\n" +
        trace + "\n";

    sendIntent.putExtra(android.content.Intent.EXTRA_EMAIL,
                        new java.lang.String[] {email});
    sendIntent.putExtra(android.content.Intent.EXTRA_TEXT, body);
    sendIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, subject);
    sendIntent.setType("message/rfc822");

    app.startActivity(android.content.Intent.createChooser(sendIntent, "Send " + subject));

    app.deleteFile(filename);

    return true;
}
