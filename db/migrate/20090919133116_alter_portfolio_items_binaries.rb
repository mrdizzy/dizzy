class AlterPortfolioItemsBinaries < ActiveRecord::Migration
  def self.up
    PortfolioItem.all.each do |p|
      p.image_content_type = "image/png"
      p.image_filename = p.portfolio_type.description.downcase.gsub(" ","_") + ".png"
      p.save!
    end
  end

  def self.down
  end
end
