##
## See tutorial http://developer.android.com/intl/ru/training/camera/photobasics.html
##

class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    # Create button. It is vertically centered.
    layout = Android::Widget::RelativeLayout.new(self)
    layout.gravity = Android::View::Gravity::CENTER

    @button = Android::Widget::Button.new(self)
    @button.text = 'Snap!'
    @button.onClickListener = self
    @button.minimumWidth = 500
    layout.addView(@button)

    @image_view_value = Android::Widget::ImageView.new(self)
    layout.addView(@image_view_value)

    self.contentView = layout

  end

  REQUEST_TAKE_PHOTO = 1
  REQUEST_IMAGE_CAPTURE = 2

  def onClick(view)
    takePictureIntent = Android::Content::Intent.new(Android::Provider::MediaStore::ACTION_IMAGE_CAPTURE)
    if takePictureIntent.resolveActivity(getPackageManager())
      # Create the File where the photo should go
      photoFile = createImageFile()

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
      galleryAddPic()
    end
    
    if requestCode == REQUEST_IMAGE_CAPTURE && resultCode == RESULT_OK
      extras = data.getExtras
      photo = extras.get("data")
      @image_view_value.setVisibility(0)
      @image_view_value.setImageBitmap(photo)
      

      # sendIntent = Android::Content::Intent.new(Android::Content::Intent::ACTION_SEND)
      # sendIntent.putExtra(Android::Content::Intent::EXTRA_STREAM, photo)
      # sendIntent.setType("image/jpeg")
      # startActivity(sendIntent)
      # startActivity(Android::Content::Intent.createChooser(shareIntent, "Send to"))

      #      media = Android::Provider::MediaStore::Images::Media.new(self)
      #      media.insertImage(getContentResolver(), photo,
      #                        "New snap!", "From Alenkator");
    end
  end

  def createImageFile()
    # Create an image file name
    timeStamp = Java::Text::SimpleDateFormat.new("yyyy-MM-dd HH:mm:ss").format(Java::Util::Date.new())
    imageFileName = "Alenkator " + timeStamp + "_"
    storageDir = Android::Os::Environment.getExternalStoragePublicDirectory(
      Android::Os::Environment::DIRECTORY_PICTURES)
    image = Java::Io::File.createTempFile(
      imageFileName, # /* prefix */
      ".jpg", #        /* suffix */
      storageDir #     /* directory */
    )

    # Save a file: path for use with ACTION_VIEW intents
    @current_photo_path = "file:" + image.getAbsolutePath()
    return image
  end

  def galleryAddPic()
    mediaScanIntent = Android::Content::Intent.new(Android::Content::Intent::ACTION_MEDIA_SCANNER_SCAN_FILE)
    f = Java::Io::File.new(@current_photo_path)
    contentUri = Android::Net::Uri.fromFile(f)
    puts contentUri
    mediaScanIntent.setData(contentUri)
    sendBroadcast(mediaScanIntent)
  end
end
