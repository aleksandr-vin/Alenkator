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

  REQUEST_IMAGE_CAPTURE = 1

  def onClick(view)
    takePictureIntent = Android::Content::Intent.new(Android::Provider::MediaStore::ACTION_IMAGE_CAPTURE)
    if takePictureIntent.resolveActivity(getPackageManager())
      startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE)
    end
  end

  def onActivityResult(requestCode, resultCode, data)
    if requestCode == REQUEST_IMAGE_CAPTURE && resultCode == RESULT_OK
      extras = data.getExtras()
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
end
