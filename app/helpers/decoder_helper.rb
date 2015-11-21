module DecoderHelper
  def file_decode(string, extension, content_type)
    return nil unless string

    data = StringIO.new(Base64.decode64(string))

    # assign some attributes for carrierwave processing
    data.class.class_eval { attr_accessor :original_filename, :content_type }
    data.original_filename = "#{SecureRandom.urlsafe_base64}.#{extension}"
    data.content_type = content_type

    # return decoded data
    data


  end
end