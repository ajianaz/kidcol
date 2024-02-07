// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gambar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGambarCollection on Isar {
  IsarCollection<Gambar> get gambars => this.collection();
}

final GambarSchema = CollectionSchema(
  name: r'Gambar',
  id: BigInt.parse("8747301943191105943").toInt(),
  properties: {
    r'endpoint': PropertySchema(
      id: BigInt.parse("0").toInt(),
      name: r'endpoint',
      type: IsarType.string,
    )
  },
  estimateSize: _gambarEstimateSize,
  serialize: _gambarSerialize,
  deserialize: _gambarDeserialize,
  deserializeProp: _gambarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'koleksis': LinkSchema(
      id: BigInt.parse("-7389097611133800399").toInt(),
      name: r'koleksis',
      target: r'Koleksi',
      single: false,
      linkName: r'gambars',
    )
  },
  embeddedSchemas: {},
  getId: _gambarGetId,
  getLinks: _gambarGetLinks,
  attach: _gambarAttach,
  version: '3.1.0',
);

int _gambarEstimateSize(
  Gambar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.endpoint.length * 3;
  return bytesCount;
}

void _gambarSerialize(
  Gambar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.endpoint);
}

Gambar _gambarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Gambar();
  object.endpoint = reader.readString(offsets[0]);
  object.id = id;
  return object;
}

P _gambarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _gambarGetId(Gambar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gambarGetLinks(Gambar object) {
  return [object.koleksis];
}

void _gambarAttach(IsarCollection<dynamic> col, Id id, Gambar object) {
  object.id = id;
  object.koleksis.attach(col, col.isar.collection<Koleksi>(), r'koleksis', id);
}

extension GambarQueryWhereSort on QueryBuilder<Gambar, Gambar, QWhere> {
  QueryBuilder<Gambar, Gambar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GambarQueryWhere on QueryBuilder<Gambar, Gambar, QWhereClause> {
  QueryBuilder<Gambar, Gambar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GambarQueryFilter on QueryBuilder<Gambar, Gambar, QFilterCondition> {
  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> endpointEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endpoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> endpointGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endpoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> endpointLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endpoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> endpointBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endpoint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> endpointStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'endpoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> endpointEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'endpoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> endpointContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'endpoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> endpointMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'endpoint',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> endpointIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endpoint',
        value: '',
      ));
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> endpointIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'endpoint',
        value: '',
      ));
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GambarQueryObject on QueryBuilder<Gambar, Gambar, QFilterCondition> {}

extension GambarQueryLinks on QueryBuilder<Gambar, Gambar, QFilterCondition> {
  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> koleksis(
      FilterQuery<Koleksi> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'koleksis');
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> koleksisLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'koleksis', length, true, length, true);
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> koleksisIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'koleksis', 0, true, 0, true);
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> koleksisIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'koleksis', 0, false, 999999, true);
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> koleksisLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'koleksis', 0, true, length, include);
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> koleksisLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'koleksis', length, include, 999999, true);
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterFilterCondition> koleksisLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'koleksis', lower, includeLower, upper, includeUpper);
    });
  }
}

extension GambarQuerySortBy on QueryBuilder<Gambar, Gambar, QSortBy> {
  QueryBuilder<Gambar, Gambar, QAfterSortBy> sortByEndpoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endpoint', Sort.asc);
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterSortBy> sortByEndpointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endpoint', Sort.desc);
    });
  }
}

extension GambarQuerySortThenBy on QueryBuilder<Gambar, Gambar, QSortThenBy> {
  QueryBuilder<Gambar, Gambar, QAfterSortBy> thenByEndpoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endpoint', Sort.asc);
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterSortBy> thenByEndpointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endpoint', Sort.desc);
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Gambar, Gambar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension GambarQueryWhereDistinct on QueryBuilder<Gambar, Gambar, QDistinct> {
  QueryBuilder<Gambar, Gambar, QDistinct> distinctByEndpoint(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endpoint', caseSensitive: caseSensitive);
    });
  }
}

extension GambarQueryProperty on QueryBuilder<Gambar, Gambar, QQueryProperty> {
  QueryBuilder<Gambar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Gambar, String, QQueryOperations> endpointProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endpoint');
    });
  }
}
