class MigrationCloudinaryJob < ActiveJob::Base
  queue_as :default

  def perform

    puts "-----------------------------------------"
    puts "MIGRATION FROM S3 TO CLOUDINARY"
    puts "-----------------------------------------"

    user_picture = 0
    User.where('picture_file_name IS NOT NULL').each do |user|
      c = Cloudinary::Uploader.upload(user.picture.url,
        crop: :limit, width: 2000, height: 2000
      )
      result = c["url"].split("http://res.cloudinary.com/dktivbech/")
      user.picture_cloud = result[1]
      user.save
      user_picture += 1
    end

    business_picture = 0
    Business.where('picture_file_name IS NOT NULL').each do |business|
      c = Cloudinary::Uploader.upload(business.picture.url,
        crop: :limit, width: 2000, height: 2000
      )
      result = c["url"].split("http://res.cloudinary.com/dktivbech/")
      business.picture_cloud = result[1]
      business.save
      business_picture += 1
    end

    business_leader_picture = 0
    Business.where('leader_picture_file_name IS NOT NULL').each do |business|
      c = Cloudinary::Uploader.upload(business.leader_picture.url,
        crop: :limit, width: 2000, height: 2000
      )
      result = c["url"].split("http://res.cloudinary.com/dktivbech/")
      business.leader_picture_cloud = result[1]
      business.save
      business_leader_picture += 1
    end

    business_logo = 0
    Business.where('logo_file_name IS NOT NULL').each do |business|
      c = Cloudinary::Uploader.upload(business.logo.url,
        crop: :limit, width: 2000, height: 2000
      )
      result = c["url"].split("http://res.cloudinary.com/dktivbech/")
      business.logo_cloud = result[1]
      business.save
      business_logo += 1
    end

    business_category_picture = 0
    BusinessCategory.where('picture_file_name IS NOT NULL').each do |business_category|
      c = Cloudinary::Uploader.upload(business_category.picture.url,
        crop: :limit, width: 2000, height: 2000
      )
      result = c["url"].split("http://res.cloudinary.com/dktivbech/")
      business_category.picture_cloud = result[1]
      business_category.save
      business_category_picture += 1
     end

    cause_picture = 0
    Cause.where('picture_file_name IS NOT NULL').each do |cause|
      c = Cloudinary::Uploader.upload(cause.picture.url,
        crop: :limit, width: 2000, height: 2000
      )
      result = c["url"].split("http://res.cloudinary.com/dktivbech/")
      cause.picture_cloud = result[1]
      cause.save
      cause_picture += 1
    end

    cause_logo = 0
    Cause.where('logo_file_name IS NOT NULL').each do |cause|
      c = Cloudinary::Uploader.upload(cause.logo.url,
        crop: :limit, width: 2000, height: 2000
      )
      result = c["url"].split("http://res.cloudinary.com/dktivbech/")
      cause.logo_cloud = result[1]
      cause.save
      cause_logo += 1
    end

    cause_category_picture = 0
    CauseCategory.where('picture_file_name IS NOT NULL').each do |cause_category|
      c = Cloudinary::Uploader.upload(cause_category.picture.url,
        crop: :limit, width: 2000, height: 2000
      )
      result = c["url"].split("http://res.cloudinary.com/dktivbech/")
      cause_category.picture_cloud = result[1]
      cause_category.save
      cause_category_picture += 1
    end

    perk_picture = 0
    Perk.where('picture_file_name IS NOT NULL').each do |perk|
      c = Cloudinary::Uploader.upload(perk.picture.url,
        crop: :limit, width: 2000, height: 2000
      )
      result = c["url"].split("http://res.cloudinary.com/dktivbech/")
      perk.picture_cloud = result[1]
      perk.save
      perk_picture += 1
    end

    puts "Nb user_picture read: #{user_picture}"
    puts "Nb user_picture uploaded: #{user_picture}"
    puts "--------------------------------------------"
    puts "Nb business_picture read: #{business_picture}"
    puts "Nb business_picture uploaded: #{business_picture}"
    puts "--------------------------------------------"
    puts "Nb business_leader_picture read: #{business_leader_picture}"
    puts "Nb business_leader_picture uploaded: #{business_leader_picture}"
    puts "--------------------------------------------"
    puts "Nb business_logo read: #{business_logo}"
    puts "Nb business_logo uploaded: #{business_logo}"
    puts "--------------------------------------------"
    puts "Nb business_category_picture read: #{business_category_picture}"
    puts "Nb business_category_picture uploaded: #{business_category_picture}"
    puts "--------------------------------------------"
    puts "Nb cause_picture read: #{cause_picture}"
    puts "Nb cause_picture uploaded: #{cause_picture}"
    puts "--------------------------------------------"
    puts "Nb cause_logo read: #{cause_logo}"
    puts "Nb cause_logo uploaded: #{cause_logo}"
    puts "--------------------------------------------"
    puts "Nb cause_category_picture read: #{cause_category_picture}"
    puts "Nb cause_category_picture uploaded: #{cause_category_picture}"
    puts "--------------------------------------------"
    puts "Nb perk_picture read: #{perk_picture}"
    puts "Nb perk_picture uploaded: #{perk_picture}"
    puts "--------------------------------------------"

  end
end

