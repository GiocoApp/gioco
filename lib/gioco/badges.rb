module Gioco
  class Badges < Core
    def self.add(rid, badge_id, resource = false, badge = false)
      resource        = get_resource( rid ) if !resource
      badge           = get_badge( badge_id ) if !badge

      if POINTS && !resource.badges.include?(badge)
        sync_resource_by_points( resource, badge.points )
      elsif !resource.badges.include?(badge)
        resource.badges << badge
      end
    end

    def self.remove( rid, badge_id, resource = false, badge = false )
      resource  = get_resource( rid ) if !resource
      badge     = get_badge( badge_id ) if !badge

      if POINTS && resource.badges.include?(badge)
        sync_resource_by_points( resource, Badge.where( "points < #{badge.points}" )[0].points  )

      elsif resource.badges.include?(badge)
        resource.levels.where( :badge_id => badge.id )[0].destroy
      end
    end
  end
end