#glue catalog
#resource "aws_glue_catalog" "cob_catalog" {
# name        = var.catalog_name 
# description = "Catalog stores tables metadata"
#}

# glue catalog database
resource "aws_glue_catalog_database" "cob_catalog_db" {
  name = var.catalog_database_name

  create_table_default_permission {
    permissions = ["SELECT"]

    principal {
      data_lake_principal_identifier = "IAM_ALLOWED_PRINCIPALS"
    }
  }
}

# glue catalog database table
resource "aws_glue_catalog_table" "cob_table" {
  name          = var.catalog_table_name  
  database_name = var.catalog_database_name  
}



# cob glue crawler
resource "aws_glue_crawler" "cob_crawler" {
  database_name = aws_glue_catalog_database.cob_catalog_db.name
  name          = var.cob-crawler_name
  role          = var.glue_role_arn

  s3_target {
    path = "s3://${var.s3_bucket_name}"
    
  }
}


