class AddRepresentativeTestimonialToCauses < ActiveRecord::Migration[5.0]
  def change
    add_column :causes, :representative_testimonial, :text
  end
end
