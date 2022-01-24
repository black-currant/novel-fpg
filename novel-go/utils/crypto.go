package utils

import (
	"crypto/hmac"
	"crypto/md5"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"math/rand"
	"novel-go/global"
	"strconv"
	"strings"
	"time"

	"github.com/golang-jwt/jwt"
	"github.com/mitchellh/mapstructure"
	"go.uber.org/zap"
	"golang.org/x/crypto/pbkdf2"
)

type JwtClaims struct {
	Aid int    `json:"aid"`
	Src string `json:"src"`
	Iat int64  `json:"iat"`
	Exp int64  `json:"exp"`
}

func EncodePassword(password string, salt string, iterations int) string {
	hash := pbkdf2.Key([]byte(password), []byte(salt), iterations, sha256.Size, sha256.New)
	hexHash := hex.EncodeToString(hash)
	return fmt.Sprintf("%s:%d$%s$%s", "pbkdf2:sha256", iterations, salt, hexHash)
}

func GenSalt(saltSize int) string {
	saltBytes := make([]byte, saltSize)
	rand.Seed(time.Now().UnixNano())
	rand.Read(saltBytes)
	return hex.EncodeToString(saltBytes)
}

func VerifyPassword(password, encoded string) (bool, error) {
	s := strings.Split(encoded, "$")
	if len(s) != 3 {
		return false, errors.New("pbkdf2: unreadable component in hashed password")
	}
	h := strings.Split(s[0], ":")
	if len(h) != 3 {
		return false, errors.New("pbkdf2: unreadable component in hashed password")
	}
	if h[0] != "pbkdf2" || h[1] != "sha256" {
		return false, errors.New("pbkdf2: algorithm mismatch")
	}
	i, err := strconv.Atoi(h[2])
	if err != nil {
		return false, errors.New("pbkdf2: unreadable component in hashed password")
	}
	return hmac.Equal([]byte(EncodePassword(password, s[1], i)), []byte(encoded)), nil
}

func CreateToken(aid uint, src string, key string, exp int) string {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"aid": aid,
		"src": src,
		"iat": time.Now().Unix(),
		"exp": time.Now().Unix() + int64(exp),
	})

	tokenString, err := token.SignedString([]byte(key))
	if nil != err {
		global.FPG_LOG.Error("signing error: %s", zap.Error(err))
		return ""
	}
	return tokenString
}

func ParseToken(tokenString string, key string) (JwtClaims, error) {
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}

		return []byte(key), nil
	})

	var jwtClaims JwtClaims
	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		if err := mapstructure.Decode(claims, &jwtClaims); err != nil {
			return jwtClaims, fmt.Errorf("signing invalid: %v", err)
		} else {
			return jwtClaims, nil
		}
	} else {
		return jwtClaims, fmt.Errorf("signing invalid: %v", err)
	}
}

func GetMd5(buf []byte) string {
	hash := md5.Sum(buf)
	md5str := fmt.Sprintf("%x", hash)
	return md5str
}
