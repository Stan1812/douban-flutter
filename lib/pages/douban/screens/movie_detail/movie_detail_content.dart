import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/pages/douban/model/movie_detail.dart';
import 'package:flutterdemo/pages/douban/widget/movie_cover.dart';

class MovieContent extends StatelessWidget {
  final MovieDetail movieDetail;
  Color pageColor;
  MovieContent(this.movieDetail, this.pageColor);

  Widget _sectionTitle(String text) {
    return Container(
      child: Text(text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
    );
  }

  Widget _buildSummary() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _sectionTitle("剧情简介"),
          Padding(padding: EdgeInsets.only(top: 10)),
          Text(
            movieDetail.summary,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ]);
  }

  Widget _buildTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _sectionTitle("相关分类"),
        Padding(padding: EdgeInsets.only(top: 10)),
        Container(
          height: 30,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movieDetail.tags.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.2),
                        borderRadius: BorderRadius.all(Radius.circular(14))),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                      child: Center(
                        child: Text(
                          movieDetail.tags[index],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget _buildCasts() {
    (movieDetail.directors ?? []).map((e) => e["type"] = "导演");
    (movieDetail.casts ?? []).map((e) => e["type"] = "演员");
    List directorAndCast = [
      ...movieDetail.directors ?? [],
      ...movieDetail.casts ?? []
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _sectionTitle("演职员"),
        Padding(padding: EdgeInsets.only(top: 10)),
        Container(
          height: 180,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: directorAndCast.length,
              itemBuilder: (BuildContext context, int index) {
                var person = directorAndCast[index];
                print(person);
                return Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Container(
                    child: GestureDetector(
                      onTap: () => {},
                      child: Container(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            MovieCoverImage(
                              person["avatars"] != null
                                  ? person["avatars"]["large"]
                                  : "http://img1.doubanio.com/f/movie/ca527386eb8c4e325611e22dfcb04cc116d6b423/pics/movie/celebrity-default-small.png",
                              width: 100,
                              height: 140,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              person["name"],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget _buildStills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _sectionTitle("预告片/剧照"),
        Padding(padding: EdgeInsets.only(top: 10)),
        Container(
          height: 140,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movieDetail.photos.length,
              itemBuilder: (BuildContext context, int index) {
                var photo = movieDetail.photos[index];
                return Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Container(
                    child: MovieCoverImage(
                      photo["thumb"],
                      width: 200,
                      height: 140,
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget _buildComments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _sectionTitle("精选短评"),
        Padding(padding: EdgeInsets.only(top: 5)),
        Container(
          child: ListView.builder(
//            禁用子list的滚动
              physics: const NeverScrollableScrollPhysics(),
              itemCount: movieDetail.popular_comments.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                var comment = movieDetail.popular_comments[index];
                print(comment);
                return Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Image(
                              image: CachedNetworkImageProvider(
                                  comment["author"]["avatar"]),
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                            ),
                            Padding(padding: EdgeInsets.only(right: 10),),
                            Text(
                              comment["author"]["name"],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Row(
                        children: <Widget>[
//                          Icon(Icons.star,color: Colors.white),
                          Text(
                            "${comment["useful_count"].toString()}有用",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    child: Text(
                      comment["content"],
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                  )
                ]);
              }),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: pageColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTags(),
              Padding(padding: EdgeInsets.only(top: 36)),
              _buildSummary(),
              Padding(padding: EdgeInsets.only(top: 36)),
              _buildCasts(),
              Padding(padding: EdgeInsets.only(top: 36)),
              _buildStills(),
              Padding(padding: EdgeInsets.only(top: 36)),
              _buildComments()
            ],
          ),
        ],
      ),
    );
  }
}
