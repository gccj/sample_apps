class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # Memo: ビジネスロジックはctrlに置くべきではない。(かつ、User#activateにすでに対応済み)
      # user.update_attribute(:activated,    true)
      # user.update_attribute(:activated_at, Time.zone.now)
      user.activate
      log_in user
      # 初回ログインはこの一回かつ要確認な物もないので、下記で十分と思います。
      flash[:success] = "初回ログインありがとうございます。"
      # 意味合い的に一緒なので、もしどうしても「Account activated!」を表示したい場合、
      # 下記のようにflash msgを追加する形で良いと思います。
      # flash[:success] = "Account activated!"
      # flash[:notice] = "初回ログインありがとうございます。"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
