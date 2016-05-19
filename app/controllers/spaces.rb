class BnByte4 < Sinatra::Base
  get '/' do
    if session[:ids_of_filtered_spaces]
      @spaces = session[:ids_of_filtered_spaces].map do |id|
        Space.get(id)
      end
    else
      @spaces = Space.all
    end
    session[:ids_of_filtered_spaces] = nil
    erb :'spaces/index'
  end

  post '/spaces' do
    Space.create(
      user: current_user,
      name: params[:name],
      description: params[:description],
    	price: params[:price],
      available_from: params[:available_from],
    	available_to: params[:available_to]
      )
    redirect '/'
  end

  get '/spaces/new' do
    erb :'/spaces/new'
  end

  post '/spaces/filtered' do
    @date_from = Date.parse(params[:available_from])
    @date_to = Date.parse(params[:available_to])
    @array_of_spaces = Space.all
    @array_of_spaces.select! do |space|
      space.available_from >= @date_from && space.available_to <= @date_to
    end
    ids = []
    @array_of_spaces.each{ |space| ids << space.id }
    if ids.any?
      session[:ids_of_filtered_spaces] = ids
    else
      flash[:notice] = 'No spaces available for selected dates'
    end
    redirect '/'
  end

  get '/spaces/request' do
    @space_id = params[:space_id]
    @space = Space.get(@space_id)
    erb :'/spaces/request'
  end
end