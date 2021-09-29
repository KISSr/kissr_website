class SitesController < ApplicationController
  before_filter :redirect_unless_subscriber, only: :new
  before_filter :authorize
  before_filter :block_cabal

  def index
    @sites = current_user.sites.all
  end

  def new
    @site = Site.new
  end

  def create
    @site = Site.new(site_params.merge(user: current_user))

    if @site.save
      redirect_to sites_path
    else
      render :new
    end
  end

  def destroy
    Site.find(params[:id]).destroy

    redirect_to sites_path
  end

  def site_params
    params.require(:site).permit(:domain)
  end

  def redirect_unless_subscriber
    unless current_user.subscriber? || current_user.sites.empty?
      redirect_to sites_path
    end
  end

  def block_cabal
    if current_user.email.include?("lemper.cf") ||
        current_user.email.include?("adrianaagathaadele93@gmail.com") ||
        current_user.email.include?("agnesiaalexandra3@gmail.com") ||
        current_user.email.include?("ali9hsali9hs@gmail.com") ||
        current_user.email.include?("alialialaiali1321@gmail.com") ||
        current_user.email.include?("alirezajirofti@gmail.com") ||
        current_user.email.include?("asdswdad@re.fgf") ||
        current_user.email.include?("astridnatalia") ||
        current_user.email.include?("bobitana") ||
        current_user.email.include?("c031119@gmail.com") ||
        current_user.email.include?("cabal") ||
        current_user.email.include?("douglassoneriade@gmail.com") ||
        current_user.email.include?("dren.h8@gmail.com") ||
        current_user.email.include?("eyeemail.com") ||
        current_user.email.include?("faranisaazniiadelia01@gmail.com") ||
        current_user.email.include?("faranisaazniiadelia01@gmail.com") ||
        current_user.email.include?("fezlopedare@gmail.com") ||
        current_user.email.include?("fredellaafsheen58@gmail.com") ||
        current_user.email.include?("go.bicelandry@gmail.com") ||
        current_user.email.include?("hojat.faraji.1381@gmail.com") ||
        current_user.email.include?("ikjklk66@gmail.com") ||
        current_user.email.include?("ismmo@protonmail.com") ||
        current_user.email.include?("jesse") ||
        current_user.email.include?("kathiggg2001@gmail.com") ||
        current_user.email.include?("killoki@yahoo.com") ||
        current_user.email.include?("leiladarelle@gmail.com") ||
        current_user.email.include?("mahdi1376faraji@gmail.com") ||
        current_user.email.include?("mail.ch") ||
        current_user.email.include?("mayparadis111@gmail.com") ||
        current_user.email.include?("milad13791379milad@gmail.com") ||
        current_user.email.include?("north8247@gmail.com") ||
        current_user.email.include?("olegsergey@ro.ru") ||
        current_user.email.include?("pacmanpacman@mail.com") ||
        current_user.email.include?("peopplemail") ||
        current_user.email.include?("perone@mail.uk") ||
        current_user.email.include?("post.cz") ||
        current_user.email.include?("rawniefathinaadia01@gmail.com") ||
        current_user.email.include?("saman137913791379@gmail.com") ||
        current_user.email.include?("solacestore") ||
        current_user.email.include?("talate.afshar1353@gmail.com") ||
        current_user.email.include?("torma-j@mail.ru") ||
        params[:site].try(:domain).try(:include?, "eth.kissr.com") ||
        params[:site].try(:domain).try(:include?, "eth") ||
        params[:site].try(:domain).try(:include?, "cabal") ||
        params[:site].try(:domain).try(:include?, "bt-onway") ||
        params[:site].try(:domain).try(:include?, "shaparak") ||
        params[:site].try(:domain).try(:include?, "pay") ||
        params[:site].try(:domain).try(:include?, "playpark")
      return render "Authorities have ben notified", status: 403
    end
  end
end
