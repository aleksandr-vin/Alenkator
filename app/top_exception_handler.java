public void dumpToFile(android.app.Activity app, java.lang.String report) {
    try {
        java.io.FileOutputStream trace =
            app.openFileOutput("stack.trace",
                               android.content.Context.MODE_PRIVATE);
        trace.write(report.getBytes());
        trace.close();
    } catch(java.io.IOException ioe) {
        // ...
    }
}
