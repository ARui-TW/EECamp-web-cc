<template>
  <FrontPageCarousel />
</template>

<script>
const AWS = require("aws-sdk")

export default {
  methods: {
    async detect_document_text () {
      const client = new AWS.Textract();
      const s3 = new AWS.S3();
      const params = {
        Document: {
          S3Object: {
            Bucket: bucket,
            Name: photo
          },
        },
      }

      const displayBlockInfo = async (response) => {
        try {
            response.Blocks.forEach(block => {
              console.log(`Block Type: ${block.BlockType}`),
              console.log(`Text: ${block.Text}`)
              console.log(`TextType: ${block.TextType}`)
              console.log(`Confidence: ${block.Confidence}`)
              console.log("-----")
            });
          } catch (err) {
            console.log("Error", err);
          }
        }

      try {
        const res = await client.detectDocumentText(params).promise();
        displayBlockInfo(res);
      } catch (err) {
        console.log("Error", err);
      }
    }
  }
};
</script>

<style lang="scss" scoped>
//
</style>
