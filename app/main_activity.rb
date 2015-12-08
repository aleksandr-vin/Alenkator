##
## See tutorial http://developer.android.com/intl/ru/training/camera/photobasics.html
##

class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    # Snap first time immediately!
    snap()

    # Then create UI...

    # Create button. It is vertically centered.
    layout = Android::Widget::RelativeLayout.new(self)
    layout.gravity = Android::View::Gravity::CENTER

    @image_view_value = Android::Widget::ImageView.new(self)
    layout.addView(@image_view_value)

    @button = Android::Widget::Button.new(self)
    @button.text = 'Snap again!'
    @button.onClickListener = self
    @button.minimumWidth = 500
    @button.minimumHeight = 500
    layout.addView(@button)


    self.contentView = layout
  end

  REQUEST_TAKE_PHOTO = 1
  REQUEST_IMAGE_CAPTURE = 2

  def onClick(view)
    snap()
  end
  
  def snap()
    takePictureIntent = Android::Content::Intent.new(Android::Provider::MediaStore::ACTION_IMAGE_CAPTURE)
    if takePictureIntent.resolveActivity(getPackageManager())
      # Create the File where the photo should go
      photoFile = createImageFilePair()

      # Continue only if the File was successfully created
      if photoFile
        takePictureIntent.putExtra(Android::Provider::MediaStore::EXTRA_OUTPUT,
                                   Android::Net::Uri.fromFile(photoFile))
        startActivityForResult(takePictureIntent, REQUEST_TAKE_PHOTO)
      end
    end
  end

  def onActivityResult(requestCode, resultCode, data)
    if requestCode == REQUEST_TAKE_PHOTO && resultCode == RESULT_OK
      setWatermark()
      galleryAddPic()
    end
    
    if requestCode == REQUEST_IMAGE_CAPTURE && resultCode == RESULT_OK
      extras = data.getExtras
      photo = extras.get("data")
      @image_view_value.setVisibility(0)
      @image_view_value.setImageBitmap(photo)
    end
  end

  def createImageFilePair()
    # Create an image file name
    @timeStamp = Java::Text::SimpleDateFormat.new("yyyy-MM-dd HH:mm:ss.SSSZ").format(Java::Util::Date.new())
    imageFileName = "Alenkator " + @timeStamp + " "
    storageDir = Android::Os::Environment.getExternalStoragePublicDirectory(
      Android::Os::Environment::DIRECTORY_PICTURES)
    image = Java::Io::File.createTempFile(
      imageFileName, # /* prefix */
      ".jpg", #        /* suffix */
      storageDir #     /* directory */
    )
    wm_image = Java::Io::File.createTempFile(
      imageFileName + " Watermarked ", # /* prefix */
      ".jpg", #        /* suffix */
      storageDir #     /* directory */
    )

    # Save a file: path for use with ACTION_VIEW intents
    @current_image = image
    @current_wm_image = wm_image
    return image
  end

  def galleryAddPic()
    mediaScanIntent = Android::Content::Intent.new(Android::Content::Intent::ACTION_MEDIA_SCANNER_SCAN_FILE)
    contentUri = Android::Net::Uri.fromFile(@current_wm_image)
    puts contentUri
    mediaScanIntent.setData(contentUri)
    sendBroadcast(mediaScanIntent)
  end

  def setWatermark()
    src = Android::Graphics::BitmapFactory.decodeFile(@current_image)

    w = src.getWidth()
    h = src.getHeight()
    result = Android::Graphics::Bitmap.createBitmap(w, h, src.getConfig())

    canvas = Android::Graphics::Canvas.new(result)
    canvas.drawBitmap(src, 0, 0, nil)

    paint = Android::Graphics::Paint.new()

    color = Android::Graphics::Color::RED
    alpha = 85
    size = 20
    underline = false
    watermark = @timeStamp
    x = 20
    y = 20
    paint.setColor(color)
    paint.setAlpha(alpha)
    paint.setTextSize(size)
    paint.setAntiAlias(true)
    paint.setUnderlineText(underline)
    canvas.drawText(watermark, x, y, paint)

    out = Java::Io::FileOutputStream.new(@current_wm_image)
    result.compress(Android::Graphics::Bitmap::CompressFormat::JPEG, 90, out)
    out.flush()
    out.close()
  end
end
