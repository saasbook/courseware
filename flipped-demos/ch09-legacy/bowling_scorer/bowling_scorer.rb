class BowlingScorer

  attr_accessor :frames, :score
  
  def initialize(frames)
    @frames = frames
  end

  def score
    @score = 0
    frames = @frames
    while frames.length > 1
      frame = frames.shift
      if frame[0] 
      end
      if frame[0] == 10
        frame_score = 20 + @frames[i+1] + @frames[i+2]
      elsif frame[0]+frame[1] == 10
        frame_score = 
      end
    end
  end
end

describe BowlingScorer do
  it "scores 20 for all ones" do
    frames = [[1,1], [1,1], [1,1], [1,1], [1,1], [1,1], [1,1], [1,1], [1,1], [1,1]]
    expect BowlingScorer.new(frames).score.to eq 20
  end
end
