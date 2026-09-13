class RemoveDuplicateTags < ActiveRecord::Migration[7.2]

  def up
    Tag.group(:name).having("COUNT(*) > 1").pluck(:name).each do |name|
      tags = Tag.where(name: name).order(:id)
      keep = tags.first

      tags.where.not(id: keep.id).find_each do |duplicate|
        TweetTagRelation.where(tag_id: duplicate.id).find_each do |relation|
          if TweetTagRelation.exists?(tweet_id: relation.tweet_id, tag_id: keep.id)
            relation.destroy!
          else
            relation.update!(tag_id: keep.id)
          end
        end

        duplicate.delete
      end
    end
  end

  def down
  end

end