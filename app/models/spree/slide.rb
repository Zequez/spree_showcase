module Spree
  class Slide < ActiveRecord::Base

    URL_PATH = "spree/showcase/:id/:style/:basename.:extension"

    has_attached_file :image,
      :styles=>{:thumb=> ["#{SpreeShowcase::Config.thumbnail_style}"],
                :showcase=> ["#{SpreeShowcase::Config.showcase_style}"]},
      :default_style => :showcase,
      :path => ":rails_root/public/#{URL_PATH}",
      :url => "/#{URL_PATH}"

    # Use the already configured S3 options in Spree
    if Spree::Config[:use_s3]
      attachment       = Spree::Slide.attachment_definitions[:image]
      spree_attachment = Spree::Image.attachment_definitions[:attachment]

      attachment.reverse_merge! spree_attachment

      attachment[:path] = URL_PATH
      attachment[:url]  = spree_attachment[:url]
    end

    default_scope order(:position) # Slides should always be ordered by position specified by user.
    scope :published, where(:published=>true)
    scope :no_slides, lambda {|num| limit(num)}
    attr_accessible :name, :body, :target_url, :published, :image, :thumbnail_message
  end
end
