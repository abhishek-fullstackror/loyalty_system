class Admin::RebateEligibilitiesController < ApplicationController
    # Checking for Cash Rebate Eligibility
    def check_cash_rebate_eligibility
        @users = []
        User.find_each do |user|
            if user.eligible_for_cash_rebate?
               @users << user
            end
        end
    end

    # Checking for Free Movie Tickets Eligibility
    def check_free_movie_tickets_eligibility
        @users = []
        User.where("created_at >= ?", 60.days.ago).each do |user|
            if user.eligible_for_free_movie_tickets?
                @users << user
            end
        end
    end
end
