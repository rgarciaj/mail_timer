require "rmagick"
module GifTimer
  module ImageMagick
    def self.combine_images(paths:, output_path:)
      `gm convert #{paths.join(' ')} +append #{output_path}`
    end

    def self.create_gif(frames:, delay:, output_path:)
      `gm convert -delay #{delay} #{frames.join(' ')}  -resize 280x93! -loop 1 -dispose previous #{output_path}`
    end
  end
end

