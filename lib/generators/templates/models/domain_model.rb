class <%= domain_model_class %> < ActiveRecord::Base

  has_one :<%= identity_model %>, inverse_of: :<%= domain_model %>, dependent: :destroy

  delegate :email, :confirmed?, to: :<%= identity_model %>

end
