module TagModerators
  class AddTrustedRole
    def self.call(user)
      return if user.has_role?(:trusted) || user.has_role?(:banned)

      user.add_role(:trusted)
      user.update(email_community_mod_newsletter: true)
      MailchimpBot.new(user).manage_community_moderator_list if community_mod_newsletter_enabled?
      Rails.cache.delete("user-#{user.id}/has_trusted_role")
      NotifyMailer.with(user: user).trusted_role_email.deliver_now
    end

    def self.community_mod_newsletter_enabled?
      SiteConfig.mailchimp_api_key.present? &&
        SiteConfig.mailchimp_community_moderators_id.present?
    end
    private_class_method :community_mod_newsletter_enabled?
  end
end
