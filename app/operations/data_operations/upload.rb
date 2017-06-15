require "aws-sdk"

module DataOperations
  class Upload < FunctionalOperations::Operation
    AWS_ID = ENV.fetch("AWS_ID", ".")
    AWS_SECRET = ENV.fetch("AWS_SECRET", ".")
    AWS_REGION = ENV.fetch("AWS_REGION", "eu-central-1")
    AWS_BUCKET = ENV.fetch("AWS_BUCKET", "feedcast")

    def arguments
      required :local_path, String
      required :remote_path, String
    end

    def perform
      bucket.object(@remote_path).upload_file(@local_path)
    end

    private

    def bucket
      s3 = Aws::S3::Resource.new(credentials: credentials, region: AWS_REGION)
      s3.bucket(AWS_BUCKET)
    end

    def credentials
      Aws::Credentials.new(AWS_ID, AWS_SECRET)
    end
  end
end
