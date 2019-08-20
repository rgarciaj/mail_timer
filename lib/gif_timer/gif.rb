module GifTimer
  class Gif
    attr_reader :time_difference
    attr_reader :show_days
    FRAME_COUNT = 60
    FRAME_DELAY = 100
    GIF_FOLDER = "./gifs"

    def initialize(time_difference, show_days)
      @time_difference = time_difference
      @show_days = show_days
    end

    def self.find_or_create(time_difference, show_days)
      gif = new(time_difference, show_days)
      gif.save unless gif.exist?
      gif
    end

    def save
      frame_paths = frames.map(&:path)
      ImageMagick.create_gif(frames: frame_paths, delay: FRAME_DELAY, output_path: path)
    end

    def path
      if show_days then
        "#{GIF_FOLDER}/#{time_difference}.gif"
      else 
        "#{GIF_FOLDER}/#{time_difference}_no_days.gif"
      end 
    end

    def exist?
      File.exist?(path)
    end

    private

    def frames
      @frames ||= frame_durations.map { |frame_time_difference| Frame.find_or_create(frame_time_difference, show_days) }
    end

    def frame_durations
      (time_difference..(time_difference + FRAME_COUNT)).to_a.reverse
    end
  end
end