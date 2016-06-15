desc 'refund expired carts'
task refund_expired_carts: :environment do
  RefundsController.refund_expired_carts
end

task refund_cancelled_carts: :environment do

end