require "rails_helper"

RSpec.describe Movie do
  subject(:movie) {
    described_class.new({
      id: 278,
      runtime: 142,
      title: "The Shawshank Redemption",
      vote_average: 8.709
    })
  }

  it { is_expected.to be_instance_of described_class }

  describe "attributes" do
    it "#id" do
      expect(movie.id).to eq(278)
    end

    it "#title" do
      expect(movie.title).to eq("The Shawshank Redemption")
    end

    it "#vote_average" do
      expect(movie.vote_average).to eq(8.709)
    end

    it "#runtime" do
      expect(movie.runtime).to eq(142)
    end
  end
end
