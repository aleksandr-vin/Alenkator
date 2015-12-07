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

  def onClick(view)

    storageDir = File.new(Environment.getExternalStoragePublicDirectory(
                           Environment.DIRECTORY_PICTURES
                         ),
                          "xxxx"
                         )

#    cameraIntent = Android::Content::Intent.new(Android::Provider::MediaStore::ACTION_IMAGE_CAPTURE)
#    startActivityForResult(cameraIntent, 0)
  end

  def onActivityResult(requestCode, resultCode, data)
    if requestCode == 0 && resultCode == RESULT_OK
      photo = data.getExtras.get("data")
      @image_view_value.setVisibility(0)
      @image_view_value.setImageBitmap(photo)

      #      media = Android::Provider::MediaStore::Images::Media.new(self)
      #      media.insertImage(getContentResolver(), photo,
#                        "New snap!", "From Alenkator");
    end
  end
end
