require "rmagick"
module GifTimer
  module ImageMagick
    def self.combine_images(paths:, output_path:)
      # `gm convert #{paths.join(' ')} +append #{output_path}`
      `gm convert #{paths.join(' ')} +append -strip -interlace Plane -quality 75% #{output_path}`
    end

    def self.create_gif(frames:, delay:, output_path:)
      `gm convert -delay #{delay} #{frames.join(' ')} -loop 0 -dispose previous #{output_path}`
    end
  end
end

