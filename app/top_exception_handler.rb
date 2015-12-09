

class TopExceptionHandler # implements Java::Lang::Thread::UncaughtExceptionHandler

  @defaultUEH

  @app = nil

  def init(app)
    @defaultUEH = Java::Lang::Thread.getDefaultUncaughtExceptionHandler()
    @app = app
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

    dumpToFile(@app, report)
    puts "stack trace saved to file"

    @defaultUEH.uncaughtException(t, e)
  end
end
