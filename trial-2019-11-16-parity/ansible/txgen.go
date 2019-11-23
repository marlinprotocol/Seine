package main

import (
	"context"
	"log"
	"math/big"
	"fmt"
	"time"
	"crypto/ecdsa"

	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
)


func main() {
	client, err := ethclient.Dial("http://127.0.0.1:8540")
	if err != nil {
		log.Fatal(err)
	}

	chainID, err := client.NetworkID(context.Background())
	if err != nil {
		log.Fatal(err)
	}
	signer := types.NewEIP155Signer(chainID)

	privateKey, err := crypto.GenerateKey()
	if err != nil {
		log.Fatal(err)
	}

	publicKey := privateKey.Public()
	publicKeyECDSA, ok := publicKey.(*ecdsa.PublicKey)
	if !ok {
		log.Fatal("cannot assert type: publicKey is not of type *ecdsa.PublicKey")
	}

	address := crypto.PubkeyToAddress(*publicKeyECDSA)

	nonce := uint64(0)

	for {
		for i := 0; i < 2; i++ {
			tx := types.NewTransaction(nonce, address, big.NewInt(0), 21000, big.NewInt(0), []byte{})
			signedTx, err := types.SignTx(tx, signer, privateKey)
			if err != nil {
				log.Fatal(err)
			}

			err = client.SendTransaction(context.Background(), signedTx)
			if err != nil {
				log.Fatal(err)
			}

			fmt.Printf("tx sent: %s\n", signedTx.Hash().Hex())

			nonce = nonce + 1
		}

		time.Sleep(100000000);
	}
}
