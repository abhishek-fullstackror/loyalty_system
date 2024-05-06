namespace :admin do
    get '/rebate_eligibilities/check_cash_rebate_eligibility', to: 'rebate_eligibilities#check_cash_rebate_eligibility', as: 'check_cash_rebate_eligibility'
    
    get '/rebate_eligibilities/check_free_movie_tickets_eligibility', to: 'rebate_eligibilities#check_free_movie_tickets_eligibility', as: 'check_free_movie_tickets_eligibility'

end