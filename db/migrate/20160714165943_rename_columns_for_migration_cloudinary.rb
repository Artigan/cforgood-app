class RenameColumnsForMigrationCloudinary < ActiveRecord::Migration
  def change
    rename_column :users, :picture_file_name, :s3_picture_file_name
    rename_column :users, :picture_content_type , :s3_picture_content_type
    rename_column :users, :picture_file_size , :s3_picture_file_size
    rename_column :users, :picture_updated_at , :s3_picture_updated_at

    rename_column :businesses, :picture_file_name, :s3_picture_file_name
    rename_column :businesses, :picture_content_type , :s3_picture_content_type
    rename_column :businesses, :picture_file_size , :s3_picture_file_size
    rename_column :businesses, :picture_updated_at , :s3_picture_updated_at

    rename_column :businesses, :leader_picture_file_name, :s3_leader_picture_file_name
    rename_column :businesses, :leader_picture_content_type , :s3_leader_picture_content_type
    rename_column :businesses, :leader_picture_file_size , :s3_leader_picture_file_size
    rename_column :businesses, :leader_picture_updated_at , :s3_leader_picture_updated_at

    rename_column :businesses, :logo_file_name, :s3_logo_file_name
    rename_column :businesses, :logo_content_type , :s3_logo_content_type
    rename_column :businesses, :logo_file_size , :s3_logo_file_size
    rename_column :businesses, :logo_updated_at , :s3_logo_updated_at

    rename_column :business_categories, :picture_file_name, :s3_picture_file_name
    rename_column :business_categories, :picture_content_type , :s3_picture_content_type
    rename_column :business_categories, :picture_file_size , :s3_picture_file_size
    rename_column :business_categories, :picture_updated_at , :s3_picture_updated_at

    rename_column :causes, :picture_file_name, :s3_picture_file_name
    rename_column :causes, :picture_content_type , :s3_picture_content_type
    rename_column :causes, :picture_file_size , :s3_picture_file_size
    rename_column :causes, :picture_updated_at , :s3_picture_updated_at

    rename_column :causes, :logo_file_name, :s3_logo_file_name
    rename_column :causes, :logo_content_type , :s3_logo_content_type
    rename_column :causes, :logo_file_size , :s3_logo_file_size
    rename_column :causes, :logo_updated_at , :s3_logo_updated_at

    rename_column :cause_categories, :picture_file_name, :s3_picture_file_name
    rename_column :cause_categories, :picture_content_type , :s3_picture_content_type
    rename_column :cause_categories, :picture_file_size , :s3_picture_file_size
    rename_column :cause_categories, :picture_updated_at , :s3_picture_updated_at

    rename_column :perks, :picture_file_name, :s3_picture_file_name
    rename_column :perks, :picture_content_type , :s3_picture_content_type
    rename_column :perks, :picture_file_size , :s3_picture_file_size
    rename_column :perks, :picture_updated_at , :s3_picture_updated_at
  end
end
