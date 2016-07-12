class MigrationCloudinaryJob < ActiveJob::Base
  queue_as :default

  def perform

    puts "-----------------------------------------"
    puts "MIGRATION FROM S3 TO CLOUDINARY"
    puts "-----------------------------------------"

    user_picture = 0
    c = User.where('picture_file_name IS NOT NULL').each do |user|
      Cloudinary::Uploader.upload(user.picture.url,
        public_id: "#{Rails.env}/user/picture_file_name.to_s",
        crop: :limit, width: 2000, height: 2000
      )
      # Cloudinary::Uploader.upload(user.picture.url,
      #   crop: :limit, width: 600, height: 600,
      #   folder: "user",
      #   tag: "picture",
      #   public_id: "#{user.picture_file_name.to_s}",
      #   eager: { width: 100, height: 100, dpr: 2.0,
      #            crop: :fill, gravity: :face })

      puts c
      # user.picture_cloud =
      user_picture += 1
    end

    # business_picture = 0
    # business_leader_picture = 0
    # business_logo = 0
    # Business.where('picture_file_name IS NOT NULL').each do |business|
    #   Cloudinary::Uploader.upload(business.picture.url.to_s)
    #   business_picture += 1
    # end
    # Business.where('leader_picture_file_name IS NOT NULL').each do |business|
    #   Cloudinary::Uploader.upload(business.leader_picture.url.to_s)
    #   business_leader_picture += 1
    # end
    # Business.where('logo_file_name IS NOT NULL').each do |business|
    #   Cloudinary::Uploader.upload(business.logo.url.to_s)
    #   business_logo += 1
    # end

    # business_category_picture = 0
    # BusinessCategory.where('picture_file_name IS NOT NULL').each do |business_category|
    #   Cloudinary::Uploader.upload(business_category.picture.url.to_s)
    #   business_category_picture += 1
    # end

    # cause_picture = 0
    # cause_logo = 0
    # Cause.where('picture_file_name IS NOT NULL').each do |cause|
    #   Cloudinary::Uploader.upload(cause.picture.url.to_s)
    #   cause_picture += 1
    # end
    # Cause.where('logo_file_name IS NOT NULL').each do |cause|
    #   Cloudinary::Uploader.upload(cause.logo.url.to_s)
    #   cause_logo += 1
    # end

    # cause_category_picture = 0
    # CauseCategory.where('picture_file_name IS NOT NULL').each do |cause_category|
    #   Cloudinary::Uploader.upload(cause_category.picture.url.to_s)
    #   cause_category_picture += 1
    # end

    # perk_picture = 0
    # Perk.where('picture_file_name IS NOT NULL').each do |perk|
    #   Cloudinary::Uploader.upload(perk.picture.url.to_s)
    #   perk_picture += 1
    # end

    puts "Nb user_picture read: #{user_picture}"
    puts "Nb user_picture uploaded: #{user_picture}"
    puts "--------------------------------------------"
    # puts "Nb business_picture read: #{business_picture}"
    # puts "Nb business_picture uploaded: #{business_picture}"
    # puts "--------------------------------------------"
    # puts "Nb business_leader_picture read: #{business_leader_picture}"
    # puts "Nb business_leader_picture uploaded: #{business_leader_picture}"
    # puts "--------------------------------------------"
    # puts "Nb business_logo read: #{business_logo}"
    # puts "Nb business_logo uploaded: #{business_logo}"
    # puts "--------------------------------------------"
    # puts "Nb business_category_picture read: #{business_category_picture}"
    # puts "Nb business_category_picture uploaded: #{business_category_picture}"
    # puts "--------------------------------------------"
    # puts "Nb cause_picture read: #{cause_picture}"
    # puts "Nb cause_picture uploaded: #{cause_picture}"
    # puts "--------------------------------------------"
    # puts "Nb cause_logo read: #{cause_logo}"
    # puts "Nb cause_logo uploaded: #{cause_logo}"
    # puts "--------------------------------------------"
    # puts "Nb cause_category_picture read: #{cause_category_picture}"
    # puts "Nb cause_category_picture uploaded: #{cause_category_picture}"
    # puts "--------------------------------------------"
    # puts "Nb perk_picture read: #{perk_picture}"
    # puts "Nb perk_picture uploaded: #{perk_picture}"
    # puts "--------------------------------------------"

  end
end

