class PictureUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  process eager: true # Force version generation at upload time
  # process convert: 'jpg'
  cloudinary_transformation :transformation => [
      {:width => 2000, :height => 2000, :crop => :limit, },
      :use_filename => true
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
    cloudinary_transformation :width => 100, :height => 100, :crop => :thumb, :gravity => :face, dpr: 2.0
  end

end
