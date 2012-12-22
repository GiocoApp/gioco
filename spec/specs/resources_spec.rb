require 'spec_helper'

describe Gioco::Resources do
  let(:user) { FactoryGirl.create(:user) }
  let(:type) { Type.find_by_name "comments" }
  let(:noob_badge) { Badge.find_by_name "noob" }
  let(:medium_badge) { Badge.find_by_name "medium" }

  context "Get a new resource and add and remove points to it" do

    it "should have nil as value of points" do
      user.points.should == []
    end

    context "Incressing points to an user win noob badge of type comment" do

      it "Add the noob badge and the points related to an user" do
        Gioco::Resources.change_points( user.id, noob_badge.points, type.id )
        user.reload
        user.badges.should include noob_badge
        user.points.where(:type_id => type.id).sum(:value) == noob_badge.points
      end

      it "Add points related to a user's type, using single increases" do
        final_score = 4
        final_score.times do
          Gioco::Resources.change_points( user.id, 1, type.id)
        end
        user.points.where(:type_id => type.id).sum(:value).should == final_score
      end

      it "Remove points related to a user's type, using single decreases" do
        initial_score = 10
        final_score = 4
        Gioco::Resources.change_points( user.id, initial_score, type.id)
        (initial_score - final_score).times do
          Gioco::Resources.change_points( user.id, -1, type.id)
        end
        user.points.where(:type_id => type.id).sum(:value).should == final_score
      end

    end

    context "Decressing points to an user loose meidum badge" do

      before(:all) do
        Gioco::Resources.change_points( user.id, medium_badge.points, type.id )
      end

      it "Remove the medium badge and the points related" do
        Gioco::Resources.change_points( user.id, - medium_badge.points, type.id )
        user.reload
        user.badges.should_not include medium_badge
        user.points.where(:type_id => type.id).sum(:value) == 0
      end

    end

  end

end