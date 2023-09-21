variable "resume_record_name" {
  description = "The record that the resume will be served from within 'zone'"
}

variable "zone_name" {
  description = "The Route53 DNS zone resumes will be served from. Will error if the zone does not already exist within Route53."
}

variable "resume_file_name" {
  description = "The file name of the resume generated by Make, like 'resume'"
}
