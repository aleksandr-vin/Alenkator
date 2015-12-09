

class TopExceptionHandler # implements Java::Lang::Thread::UncaughtExceptionHandler

  def init(app)
    @defaultUEH = Java::Lang::Thread.getDefaultUncaughtExceptionHandler()
    @app = app
    @filename = "stack.trace"
    @email = "aleksandr.vin+alenkator@gmail.com"
  end

  def uncaughtException(t, e)
    arr = e.getStackTrace()
    report = e.toString() + "\n\n"
    report += "--------- Stack trace ---------\n\n"
    for arri in arr do
      report += "    " + arri.toString() + "\n"
    end
    report += "-------------------------------\n\n"

    # If the exception was thrown in a background thread inside
    # AsyncTask, then the actual exception can be found with getCause
    report += "--------- Cause ---------\n\n"
    cause = e.getCause()
    if cause != nil
      report += cause.toString() + "\n\n"
      arr = cause.getStackTrace()
      for arri in arr do
        report += "    " + arri.toString() + "\n"
      end
    end
    report += "-------------------------------\n\n"

    puts "~~~~~~~~~~~~~~~~start~~~~~~~~~~~~~~~~"
    puts report
    puts "~~~~~~~~~~~~~~~~~end~~~~~~~~~~~~~~~~~"

    dumpToFile(@app, report, @filename)
    puts "stack trace saved to file"

    @defaultUEH.uncaughtException(t, e)
  end

  def checkSavedFile()
    puts "Checking saved stack trace..."
    trace = ""
    begin
      reader = Java::Io::BufferedReader.new(
        Java::Io::InputStreamReader.new(@app.openFileInput(@filename)))
      while (line = reader.readLine()) != nil do
        trace += line + "\n"
      end
    rescue Java::Io::FileNotFoundException => fnfe
      puts "File not found: " + fnfe.message
      return
    rescue Java::Io::IOException => ioe
      puts "IOException: " + ioe.message
      return
    end

    puts "Saved stack trace file found, skipping"
  end

  def checkAndSendStackTrace()
    checkSavedFile()
    return _checkAndSendStackTrace(@app, @filename, @email)
  end
end
