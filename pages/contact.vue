<template>
  <v-container>
    <div class="text-Heading30">聯絡我們</div>
    <v-divider class="my-4" />
    <div class="text-Heading20 d-flex justify-center">
      有任何問題可以透過以下方式聯絡我們：
    </div>
    <SizeBox height="20" />
    <v-btn
      href="https://www.facebook.com/NTHUEECAMP/"
      target="_blank"
      color="#3b5998"
      class="secondary900--text text-Global18"
      width="100%"
      height="50px"
    >
      <v-icon large>mdi-facebook</v-icon>
      <SizeBox width="10" />
      Facebook 粉絲專頁
    </v-btn>

    <SizeBox width="10" />
    <v-btn @click="detect_document_text"
      color="#3b5998"
      class="secondary900--text text-Global18"
      width="100%"
      height="50px">
      page test
    </v-btn>


    <SizeBox height="20" />
    <v-card elevation="2" color="#17a2b8" class="secondary900--text pa-4">
      總籌：{{ contactInfo.convenor }}
      <br />
      手機：{{ contactInfo.convenorPhone }}
      <br />
      聯絡時間：週一至週五 晚上 6 - 10 時，週六日整天
    </v-card>
    <SizeBox height="20" />
    <v-card elevation="2" color="#28a745" class="secondary900--text pa-4">
      招生負責人：{{ contactInfo.inCharge }}
      <br />
      手機：{{ contactInfo.inChargePhone }}
      <br />
      聯絡時間：週一至週五 晚上6 - 10 時，週六日整天
    </v-card>
    <SizeBox height="20" />
    <v-card elevation="2" color="#dc3545" class="secondary900--text pa-4">
      官方e-mail：
      <a
        href="mailto:officialnthueecamp@gmail.com"
        class="secondary900--text text-decoration-none"
      >
        officialnthueecamp@gmail.com
      </a>
    </v-card>
    <SizeBox height="20" />
    <v-card elevation="2" color="#007bff" class="secondary900--text pa-4">
      郵寄地址：新竹郵政2-263信箱（
      <a
        href="/images/mail.jpeg"
        target="_blank"
        class="secondary900--text text-decoration-none"
      >
        郵寄範例
      </a>
      ）
    </v-card>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex';

import { Amplify } from 'aws-amplify';
import { TextractClient, DetectDocumentTextCommand } from "@aws-sdk/client-textract";


export default {
  computed: {
    ...mapGetters({
      contactInfo: 'Web/GetContactInfo'
    })
  },
  methods: {

    async detect_document_text () {
      const textractClient = new TextractClient({ 
        region: "ap-southeast-1",
        credentials:{
          accessKeyId: "AKIAQWJ33T5XRSIU4BSP",
          secretAccessKey: "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"
        }
        });
      const params = {
        Document: {
          S3Object: {
            Bucket: "textract-cc-final",
            Name: "test222.png"
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
        const doc = new DetectDocumentTextCommand(params);
        const res = await textractClient.send(doc);
        displayBlockInfo(res);
      } catch (err) {
        console.log("Error", err);
      }
    }
  },
  mounted() {
    Amplify.configure({
      Auth: {
        identityPoolId: 'ap-southeast-1:3a95d619-85f6-4774-8fbb-ea85a83d972c', // (required) - Amazon Cognito Identity Pool ID
        region: 'ap-southeast-1', // (required) - Amazon Cognito Region
        userPoolId: 'ap-southeast-1_zEY3izLtf', // (optional) - Amazon Cognito User Pool ID
        userPoolWebClientId: '1d419huvu44gm5vgkp9ue4v997' // (optional) - Amazon Cognito Web Client ID (App client secret needs to be disabled)
      },
      Storage: {
        AWSS3: {
          bucket: 'textract-cc-final', // (required) -  Amazon S3 bucket name
          region: 'ap-southeast-1' // (optional) -  Amazon service region
        }
      }
    });
  }
};
</script>


<style lang="scss" scoped>
//
</style>
