class RemoveColumnS3FromMultipleModels < ActiveRecord::Migration
  def change
    remove_column :users, :s3_picture_file_name
    remove_column :users, :s3_picture_content_type
    remove_column :users, :s3_picture_file_size
    remove_column :users, :s3_picture_updated_at

    remove_column :businesses, :s3_picture_file_name
    remove_column :businesses, :s3_picture_content_type
    remove_column :businesses, :s3_picture_file_size
    remove_column :businesses, :s3_picture_updated_at

    remove_column :businesses, :s3_leader_picture_file_name
    remove_column :businesses, :s3_leader_picture_content_type
    remove_column :businesses, :s3_leader_picture_file_size
    remove_column :businesses, :s3_leader_picture_updated_at

    remove_column :businesses, :s3_logo_file_name
    remove_column :businesses, :s3_logo_content_type
    remove_column :businesses, :s3_logo_file_size
    remove_column :businesses, :s3_logo_updated_at

    remove_column :business_categories, :s3_picture_file_name
    remove_column :business_categories, :s3_picture_content_type
    remove_column :business_categories, :s3_picture_file_size
    remove_column :business_categories, :s3_picture_updated_at

    remove_column :causes, :s3_picture_file_name
    remove_column :causes, :s3_picture_content_type
    remove_column :causes, :s3_picture_file_size
    remove_column :causes, :s3_picture_updated_at

    remove_column :causes, :s3_logo_file_name
    remove_column :causes, :s3_logo_content_type
    remove_column :causes, :s3_logo_file_size
    remove_column :causes, :s3_logo_updated_at

    remove_column :cause_categories, :s3_picture_file_name
    remove_column :cause_categories, :s3_picture_content_type
    remove_column :cause_categories, :s3_picture_file_size
    remove_column :cause_categories, :s3_picture_updated_at

    remove_column :perks, :s3_picture_file_name
    remove_column :perks, :s3_picture_content_type
    remove_column :perks, :s3_picture_file_size
    remove_column :perks, :s3_picture_updated_at


  end
end
