class PictureUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  process eager: true # Force version generation at upload time
  process convert: 'jpg'
  cloudinary_transformation :transformation => [
      {:width => 1200, :height => 1200, :crop => :limit},
    ]


  version :standard do |variable|
    resize_to_fit(800, 600)
  end

  version :card do |variable|
    resize_to_fit(350, 250)
  end

  version :thumb do |variable|
    resize_to_fill(100, 100)
  end

  version :avatar do |variable|
    cloudinary_transformation :width => 100, :height => 100, :crop => :thumb, :gravity => :face
  end

end
