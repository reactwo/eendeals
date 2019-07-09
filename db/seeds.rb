# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def check_and_return(users)
  users.each do |user|
    if user.down_user.user_refers.where(level: 1).count < 5
      return user.down_user
    end
  end
end

def find_sponsor(sponsor_id)
  top_user = User.find_by_refer_id sponsor_id
  if top_user.user_refers.where(level: 1).count < 5
    top_user
  elsif top_user.user_refers.where(level: 2).count < 25
    return check_and_return top_user.user_refers.where(level: 1)
  elsif top_user.user_refers.where(level: 3).count < 125
    return check_and_return top_user.user_refers.where(level: 2)
  elsif top_user.user_refers.where(level: 4).count < 625
    return check_and_return top_user.user_refers.where(level: 3)
  elsif top_user.user_refers.where(level: 5).count < 3125
    return check_and_return top_user.user_refers.where(level: 4)
  elsif top_user.user_refers.where(level: 6).count < 15625
    return check_and_return top_user.user_refers.where(level: 5)
  elsif top_user.user_refers.where(level: 7).count < 78125
    return check_and_return top_user.user_refers.where(level: 6)
  elsif top_user.user_refers.where(level: 8).count < 390625
    return check_and_return top_user.user_refers.where(level: 7)
  elsif top_user.user_refers.where(level: 9).count < 1953125
    return check_and_return top_user.user_refers.where(level: 8)
  elsif top_user.user_refers.where(level: 10).count < 9765625
    return check_and_return top_user.user_refers.where(level: 9)
  else
    return check_and_return top_user.user_refers.where(level: 10)
  end
end

Setting.create([
                   {
                       name: 'ppv1_limit',
                       value: 5,
                       kind: Setting::SETTING_KIND[:integer],
                   },
                   {
                       name: 'ppv2_limit',
                       value: 5,
                       kind: Setting::SETTING_KIND[:integer],
                   },
                   {
                       name: 'ppv1_amount',
                       value: 0.5,
                       kind: Setting::SETTING_KIND[:float],
                   },
                   {
                       name: 'ppv2_amount',
                       value: 1,
                       kind: Setting::SETTING_KIND[:float],
                   },
                   {
                       name: 'refer_ids',
                       value: '000000',
                       kind: Setting::SETTING_KIND[:string],
                   },
                   {
                       name: 'app_version',
                       value: 12,
                       kind: Setting::SETTING_KIND[:integer],
                   },
                   {
                       name: 'game_minutes',
                       value: 5,
                       kind: Setting::SETTING_KIND[:integer]
                   },
                   {
                       name: 'game_coins',
                       value: 0.25,
                       kind: Setting::SETTING_KIND[:float]
                   },
                   {
                       name: 'telegram',
                       value: '',
                       kind: Setting::SETTING_KIND[:string]
                   },
                   {
                       name: 'whatsapp',
                       value: '',
                       kind: Setting::SETTING_KIND[:string]
                   },
                   {
                       name: 'screen_lock',
                       value: '',
                       kind: Setting::SETTING_KIND[:string]
                   },
                   {
                       name: 'screen_lock_video',
                       value: '',
                       kind: Setting::SETTING_KIND[:string]
                   },
                   {
                       name: 'spin_wheel',
                       value: '',
                       kind: Setting::SETTING_KIND[:string]
                   },
                   {
                       name: 'news_app',
                       value: '',
                       kind: Setting::SETTING_KIND[:string]
                   }
               ])

begin
  u = User.create!(name: 'Eendeals Admin', mobile: '123456789', password: 'parry123', gender: 1, refer_id: '000000', sponsor_id: 'BINDRA', status: 3)
  u.add_role :admin
rescue
  puts 'Admin already exists'
end

name = %w(Alex Surinder Mona Monica Aoibhinn Aoife Ava Brooke Caitlin Caoimhe Cara Charlotte Chloe Ciara Clara Clodagh Daisy Eabha Eimear Elizabeth Ella Natalia Niamh Nicole Olivia Orla Poppy Rachel Rebecca Robyn Roisin Rose Ruby Ruth Sadhbh Sadie Saoirse Sara Sarah Sienna Sofia Sophia Sophie Tara Victoria Darcey Darcy Eleanor Eliza Elizabeth Ella Ellie Elsie Emilia Emily Emma Erin Esme Eva Evelyn Evie Faith Florence Francesca Freya Georgia Grace Gracie Hannah Harriet Heidi Hollie Holly Imogen Isabel Isabella Isabelle Isla Isobel Ivy Jasmine Jessica Julia Katie Keira Lacey Layla Leah Lexi Lilly Lily Lola Lucy Lydia Maddison Madison Maisie Maria Martha Maryam Matilda Maya Megan Mia Millie Mollie Molly Niamh Olivia Paige Phoebe Poppy Rose Rosie Ruby Sara Sarah Scarlett Sienna Skye Sofia Sophia Sophie Summer Tilly Victoria Violet Willow Zara Zoe Supreet Rohini Roshni Monika Reeta Rajni Komal Siman Mandeep aarti aarzo ashima Susma Ananya Angana Anamika Anupreet Sanmeet Navdeep Jasmeet Jaspreet Ela Seema Deepika Anushka)

(1..155).each do |num|
  id = '%06d' % num
  mobile = '%010d' % num

  u = User.create!(name: "#{name[num - 1]}", mobile: mobile, password: Devise.friendly_token, gender: User::GENDER[:female], refer_id: id, status: 3)

  real_sponsor = User.where(refer_id: '000000')
  if real_sponsor.count > 0
    sponsor = find_sponsor real_sponsor.last.refer_id
    level = 1

    User.transaction do
      u.update(sponsor: sponsor, real_sponsor: real_sponsor.last)

      # t = Transaction.new(
      #     amount: 5,
      #     user: real_sponsor.last,
      #     category: Transaction::CATEGORY[:refer],
      #     direction: Transaction::DIRECTION[:credit],
      #     from_user: current_user,
      #     from_user_status: current_user.status
      # )
      # t.save
      # wallet = real_sponsor.last.wallet
      # wallet.passive += 5
      # wallet.save

      # level_income = [7, 7, 6, 5, 4, 4, 3, 3, 3, 3]

      while sponsor
        ur = UserRefer.new(down_user: u, user: sponsor, level: level)
        ur.save

        # t = Transaction.new(
        #     amount: level_income[level - 1],
        #     user: sponsor,
        #     category: Transaction::CATEGORY[:refer],
        #     direction: Transaction::DIRECTION[:credit],
        #     from_user: current_user,
        #     from_user_status: current_user.status
        # )
        # t.save
        # wallet = sponsor.wallet
        # wallet.passive += level_income[level - 1]
        # wallet.save

        sponsor = sponsor.sponsor
        level += 1
        if level > 10
          break
        end
      end
    end
  end
end

app = Rpush::Gcm::App.new
app.name = 'Eendeals'
app.auth_key = 'AAAAi-aL6cE:APA91bHECcoHNC5hL7vAsmH2U9EifCetXNFOGVNJfotymZhheUMLnaHE-6MwT7UY7qL_tCFm5WXzWQ_xnVNdm8QeAF10KUKuHFgZZfoiXjjgdW64bPAL__Q81qqN3j9629gVHPAG2p11'
app.connections = 1
app.save!