class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort_by = params[:sort]
    @ratings = params[:ratings]
    if (@ratings != nil)
      ratings = @ratings.keys
    else
      ratings = Movie.ratings
    end

    @all_ratings = Movie.ratings.inject(Hash.new) do |all_ratings, rating|
        if(@ratings != nil)
          all_ratings[rating] = @ratings.has_key?(rating)
        else
          all_ratings[rating] = false
        end
        all_ratings
      end

    if (@sort_by != nil)
        @movies = Movie.order("#{@sort_by} ASC").find_all_by_rating(ratings)
    else
        @movies = Movie.find_all_by_rating(ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
