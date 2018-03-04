FROM ruby
COPY terrify.rb /usr/local/bin/
CMD ["terrify.rb", "hcl"]