namespace :docker do
  desc 'Push docker images to DockerHub'
  task push_image: :environment do
    TAG = `git rev-parse --short HEAD`.strip

    puts 'Building Docker image for Nginx'
    sh "docker build -f docker/nginx/Dockerfile -t kaynassassin/nginx-rate-limiter:#{TAG} ."

    IMAGE_ID = `docker images | grep kaynassassin\/nginx-rate-limiter | head -n1 | awk '{print $3}'`.strip

    puts 'Tagging latest image'
    sh "docker tag #{IMAGE_ID} kaynassassin/nginx-rate-limiter:latest"

    puts 'Pushing Docker image'
    sh "docker push kaynassassin/nginx-rate-limiter:#{TAG}"
    sh 'docker push kaynassassin/nginx-rate-limiter:latest'

    puts 'Building Docker image for Rails'
    sh "docker build -f docker/rails/Dockerfile -t kaynassassin/rails-rate-limiter:#{TAG} ."

    IMAGE_ID = `docker images | grep kaynassassin\/rails-rate-limiter | head -n1 | awk '{print $3}'`.strip

    puts 'Tagging latest image'
    sh "docker tag #{IMAGE_ID} kaynassassin/rails-rate-limiter:latest"

    puts 'Pushing Docker image'
    sh "docker push kaynassassin/rails-rate-limiter:#{TAG}"
    sh 'docker push kaynassassin/rails-rate-limiter:latest'

    puts 'Done'
  end
end
