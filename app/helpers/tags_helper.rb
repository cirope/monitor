module TagsHelper
  def tag_kinds
    {
      script: Script.model_name.human(count: 0),
      issue:  Issue.model_name.human(count: 0),
      user:   User.model_name.human(count: 0)
    }
  end
end
